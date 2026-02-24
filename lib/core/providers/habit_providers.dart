import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../main.dart';
import '../../features/habits/data/models/habit.dart';
import '../../features/habits/data/repositories/habit_repository.dart';

/// Provider for the database instance
final databaseProvider = Provider((ref) => database);

/// Provider for HabitRepository
final habitRepositoryProvider = Provider<HabitRepository>((ref) {
  return HabitRepository(ref.watch(databaseProvider));
});

/// Provider for all habits
final habitsProvider = StreamProvider<List<HabitModel>>((ref) {
  final repository = ref.watch(habitRepositoryProvider);
  return repository.watchAllHabits();
});

/// Stream Provider for a single habit by ID (reactive)
final habitProvider = StreamProvider.family<HabitModel?, int>((ref, id) {
  final repository = ref.watch(habitRepositoryProvider);
  return repository.watchHabitById(id);
});

/// Provider for today's date (normalized to midnight)
final todayProvider = Provider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
});

/// Stream Provider for today's completions (reactive)
final todayCompletionsProvider =
    StreamProvider<List<HabitCompletionModel>>((ref) {
  final repository = ref.watch(habitRepositoryProvider);
  return repository.watchTodayCompletions();
});

/// Provider to check if a specific habit is completed today
final isHabitCompletedTodayProvider =
    Provider.family<bool, int>((ref, habitId) {
  final completionsAsync = ref.watch(todayCompletionsProvider);

  return completionsAsync.when(
    data: (completions) => completions.any((c) => c.habitId == habitId),
    loading: () => false,
    error: (_, __) => false,
  );
});

/// Provider for today's completion count for a specific habit
final habitCompletionCountTodayProvider =
    Provider.family<int, int>((ref, habitId) {
  final completionsAsync = ref.watch(todayCompletionsProvider);

  return completionsAsync.when(
    data: (completions) {
      final completion =
          completions.where((c) => c.habitId == habitId).firstOrNull;
      return completion?.count ?? 0;
    },
    loading: () => 0,
    error: (_, __) => 0,
  );
});

/// Provider for current streak count for a habit
final habitStreakProvider =
    FutureProvider.family<int, int>((ref, habitId) async {
  final repository = ref.watch(habitRepositoryProvider);
  return await repository.calculateStreak(habitId);
});

/// Provider for overall streak (any habit completed per day)
final overallStreakProvider = FutureProvider<int>((ref) async {
  final today = ref.watch(todayProvider);
  final db = ref.watch(databaseProvider);
  final habits = await ref.read(habitsProvider.future);

  if (habits.isEmpty) return 0;

  var currentDate = today;
  var streak = 0;
  var lookbackAttempts = 0;
  const maxLookback = 2; // Only check today and yesterday when streak==0

  while (true) {
    // Check each habit for a completion on currentDate
    bool anyCompleted = false;
    for (final habit in habits) {
      if (habit.id == null) continue;
      final completion = await db.getCompletionForDate(habit.id!, currentDate);
      if (completion != null) {
        anyCompleted = true;
        break;
      }
    }

    if (!anyCompleted) {
      // If we haven't started a streak yet, allow checking yesterday
      if (streak == 0 && lookbackAttempts < maxLookback) {
        lookbackAttempts++;
        currentDate = currentDate.subtract(const Duration(days: 1));
        continue;
      }
      break;
    }

    streak++;
    currentDate = currentDate.subtract(const Duration(days: 1));

    // Safety limit
    if (streak > 365) break;
  }

  return streak;
});

/// Provider for today's progress percentage
final todayProgressProvider = Provider<double>((ref) {
  final habitsAsync = ref.watch(habitsProvider);
  final completionsAsync = ref.watch(todayCompletionsProvider);

  return habitsAsync.when(
    data: (habits) {
      if (habits.isEmpty) return 0;

      return completionsAsync.when(
        data: (completions) {
          final completedCount =
              completions.map((c) => c.habitId).toSet().length;
          return completedCount / habits.length * 100;
        },
        loading: () => 0,
        error: (_, __) => 0,
      );
    },
    loading: () => 0,
    error: (_, __) => 0,
  );
});

/// Stream Provider for habit completions in a specific month (reactive)
final habitMonthCompletionsProvider =
    StreamProvider.family<List<int>, ({int habitId, DateTime month})>(
        (ref, arg) {
  final repository = ref.watch(habitRepositoryProvider);
  final start = DateTime(arg.month.year, arg.month.month, 1);
  final end = DateTime(arg.month.year, arg.month.month + 1, 0, 23, 59, 59);

  return repository
      .watchCompletionsForHabit(arg.habitId, start, end)
      .map((completions) => completions.map((c) => c.date.day).toList());
});

/// Stream Provider for weekly progress rates
final weeklyProgressProvider = StreamProvider<List<double>>((ref) {
  final habitsAsync = ref.watch(habitsProvider);
  final now = DateTime.now();
  final startOfWeek = DateTime(now.year, now.month, now.day - 6);
  final endOfWeek = DateTime(now.year, now.month, now.day, 23, 59, 59);

  return habitsAsync.when(
    data: (habits) {
      if (habits.isEmpty) return Stream.value(List.filled(7, 0.0));

      final repository = ref.watch(habitRepositoryProvider);
      return repository
          .watchCompletionsForDateRange(startOfWeek, endOfWeek)
          .map((allCompletions) {
        final List<double> rates = [];
        for (int i = 6; i >= 0; i--) {
          final day = DateTime(now.year, now.month, now.day - i);
          int completedHabitsForDay = 0;

          for (final habit in habits) {
            final completionsForHabitDay = allCompletions.where((c) =>
                c.habitId == habit.id &&
                c.date.year == day.year &&
                c.date.month == day.month &&
                c.date.day == day.day);
            if (completionsForHabitDay.isNotEmpty) {
              completedHabitsForDay++;
            }
          }
          rates.add(habits.isNotEmpty
              ? (completedHabitsForDay / habits.length * 100)
              : 0);
        }
        return rates;
      });
    },
    loading: () => Stream.value(List.filled(7, 0.0)),
    error: (_, __) => Stream.value(List.filled(7, 0.0)),
  );
});
