import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/notification_providers.dart';
import 'habit_providers.dart';
import 'gamification_providers.dart';
import '../../features/habits/data/models/habit.dart';

/// Notifier for managing habit operations
class HabitNotifier extends Notifier<void> {
  @override
  void build() {}

  /// Create a new habit
  Future<int> createHabit({
    required String name,
    required String emoji,
    required HabitCategory category,
    required HabitFrequency frequency,
    required String colorHex,
    int targetCount = 1,
    int priority = 1,
    String? description,
    String? reminderTime,
    bool reminderEnabled = false,
    List<int>? customDays,
    bool isTimed = false,
    int? timerDuration,
  }) async {
    final now = DateTime.now();
    final habit = HabitModel(
      name: name,
      emoji: emoji,
      category: category,
      frequency: frequency,
      colorHex: colorHex,
      targetCount: targetCount,
      priority: priority,
      description: description,
      reminderTime: reminderTime,
      reminderEnabled: reminderEnabled,
      customDays: customDays?.join(','),
      isTimed: isTimed,
      timerDuration: timerDuration,
      createdAt: now,
      updatedAt: now,
    );

    final repository = ref.read(habitRepositoryProvider);
    final id = await repository.createHabit(habit);

    // Schedule notification if enabled
    if (reminderEnabled && reminderTime != null) {
      await ref.read(notificationServiceProvider).scheduleHabitNotification(
            habitId: id,
            habitName: name,
            reminderTime: reminderTime,
            frequency: frequency,
            customDays: customDays,
          );
    }

    return id;
  }

  /// Update an existing habit
  Future<void> updateHabit(HabitModel habit) async {
    final repository = ref.read(habitRepositoryProvider);
    await repository.updateHabit(habit);

    // Update notification
    if (habit.reminderEnabled && habit.reminderTime != null) {
      await ref.read(notificationServiceProvider).scheduleHabitNotification(
            habitId: habit.id!,
            habitName: habit.name,
            reminderTime: habit.reminderTime!,
            frequency: habit.frequency,
            customDays: habit.customDaysList,
          );
    } else {
      await ref
          .read(notificationServiceProvider)
          .cancelHabitNotifications(habit.id!);
    }
  }

  /// Archive a habit (soft delete)
  Future<void> archiveHabit(int id) async {
    final repository = ref.read(habitRepositoryProvider);
    await repository.archiveHabit(id);
    await ref.read(notificationServiceProvider).cancelHabitNotifications(id);
  }

  /// Delete a habit permanently
  Future<void> deleteHabit(int id) async {
    final repository = ref.read(habitRepositoryProvider);
    await repository.deleteHabit(id);
    await ref.read(notificationServiceProvider).cancelHabitNotifications(id);
  }

  /// Complete a habit for today
  Future<void> completeHabit(int habitId, {String? note}) async {
    final repository = ref.read(habitRepositoryProvider);
    await repository.completeHabit(habitId, note: note);

    // Award XP
    final habit = await repository.getHabitById(habitId);
    if (habit != null) {
      final gamificationService = ref.read(gamificationServiceProvider);
      // Determine if it adheres to streak (simplified for now)
      final streak = await repository.calculateStreak(habitId);
      final isStreakMaintain =
          streak > 1; // If streak > 1, we maintained it (roughly)

      await gamificationService.addXPForHabit(habit,
          isStreakMaintain: isStreakMaintain);
    }

    ref.invalidate(overallStreakProvider);
    // Invalidate user progress provider if it existed
    ref.invalidate(userProgressProvider);
  }

  /// Uncomplete a habit for today
  Future<void> uncompleteHabit(int habitId) async {
    final repository = ref.read(habitRepositoryProvider);
    await repository.uncompleteHabit(habitId);
    ref.invalidate(overallStreakProvider);
  }

  /// Toggle habit completion for today
  Future<void> toggleHabit(int habitId) async {
    // Check if already completed today using the provider
    final isCompleted = ref.read(isHabitCompletedTodayProvider(habitId));

    if (isCompleted) {
      await uncompleteHabit(habitId);
    } else {
      await completeHabit(habitId);
    }
  }

  /// Toggle habit completion for a specific date
  Future<void> toggleHabitForDate(int habitId, DateTime date) async {
    final repository = ref.read(habitRepositoryProvider);
    final normalized = DateTime(date.year, date.month, date.day);
    final start = normalized;
    final end = normalized.add(const Duration(days: 1));

    final completions =
        await repository.getCompletionsForHabit(habitId, start, end);
    final isCompleted = completions.isNotEmpty;

    if (isCompleted) {
      await repository.uncompleteHabitForDate(habitId, date);
    } else {
      await repository.completeHabitForDate(habitId, date);
    }

    // Refresh data
  }
}

/// Provider for habit operations
final habitNotifierProvider = NotifierProvider<HabitNotifier, void>(() {
  return HabitNotifier();
});
