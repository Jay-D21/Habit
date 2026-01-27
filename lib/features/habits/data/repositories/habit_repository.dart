import '../models/habit.dart';
import '../../../../core/database/database.dart';
import 'package:drift/drift.dart';

/// Repository for habit-related database operations
class HabitRepository {
  final AppDatabase _db;

  HabitRepository(this._db);

  /// Convert Drift Habit to HabitModel
  HabitModel _toModel(HabitEntity dbHabit) {
    return HabitModel(
      id: dbHabit.id,
      name: dbHabit.name,
      emoji: dbHabit.emoji,
      category: HabitCategory.values[dbHabit.category],
      frequency: HabitFrequency.values[dbHabit.frequency],
      customDays: dbHabit.customDays,
      description: dbHabit.description,
      colorHex: dbHabit.colorHex,
      targetCount: dbHabit.targetCount,
      reminderTime: dbHabit.reminderTime,
      reminderEnabled: dbHabit.reminderEnabled,
      sortOrder: dbHabit.sortOrder,
      isArchived: dbHabit.isArchived,
      createdAt: dbHabit.createdAt,
      updatedAt: dbHabit.updatedAt,
    );
  }

  /// Convert HabitModel to Drift Companion for insert
  HabitsCompanion _toCompanion(HabitModel model) {
    return HabitsCompanion(
      name: Value(model.name),
      emoji: Value(model.emoji),
      category: Value(model.category.index),
      frequency: Value(model.frequency.index),
      customDays: Value(model.customDays),
      description: Value(model.description),
      colorHex: Value(model.colorHex),
      targetCount: Value(model.targetCount),
      reminderTime: Value(model.reminderTime),
      reminderEnabled: Value(model.reminderEnabled),
      sortOrder: Value(model.sortOrder),
      isArchived: Value(model.isArchived),
      createdAt: Value(model.createdAt),
      updatedAt: Value(model.updatedAt),
    );
  }

  /// Convert Drift HabitCompletion to HabitCompletionModel
  HabitCompletionModel _completionToModel(HabitCompletionEntity dbCompletion) {
    return HabitCompletionModel(
      id: dbCompletion.id,
      date: dbCompletion.date,
      habitId: dbCompletion.habitId,
      count: dbCompletion.count,
      note: dbCompletion.note,
      completedAt: dbCompletion.completedAt,
    );
  }

  /// Get all active (non-archived) habits
  Future<List<HabitModel>> getAllHabits() async {
    final habits = await _db.getAllHabits();
    return habits.map(_toModel).toList();
  }

  /// Get a single habit by ID
  Future<HabitModel?> getHabitById(int id) async {
    final habit = await _db.getHabitById(id);
    return habit != null ? _toModel(habit) : null;
  }

  /// Create a new habit
  Future<int> createHabit(HabitModel habit) async {
    final now = DateTime.now();
    final newHabit = habit.copyWith(
      createdAt: now,
      updatedAt: now,
    );
    return await _db.insertHabit(_toCompanion(newHabit));
  }

  /// Update an existing habit
  Future<void> updateHabit(HabitModel habit) async {
    final updatedHabit = habit.copyWith(updatedAt: DateTime.now());

    // Create a full Habit object for update
    final dbHabit = HabitEntity(
      id: updatedHabit.id!,
      name: updatedHabit.name,
      emoji: updatedHabit.emoji,
      category: updatedHabit.category.index,
      frequency: updatedHabit.frequency.index,
      customDays: updatedHabit.customDays,
      description: updatedHabit.description,
      colorHex: updatedHabit.colorHex,
      targetCount: updatedHabit.targetCount,
      reminderTime: updatedHabit.reminderTime,
      reminderEnabled: updatedHabit.reminderEnabled,
      sortOrder: updatedHabit.sortOrder,
      isArchived: updatedHabit.isArchived,
      createdAt: updatedHabit.createdAt,
      updatedAt: updatedHabit.updatedAt,
    );

    await _db.updateHabit(dbHabit);
  }

  /// Delete a habit (soft delete - archive it)
  Future<void> archiveHabit(int id) async {
    final habit = await _db.getHabitById(id);
    if (habit != null) {
      final archived = HabitEntity(
        id: habit.id,
        name: habit.name,
        emoji: habit.emoji,
        category: habit.category,
        frequency: habit.frequency,
        customDays: habit.customDays,
        description: habit.description,
        colorHex: habit.colorHex,
        targetCount: habit.targetCount,
        reminderTime: habit.reminderTime,
        reminderEnabled: habit.reminderEnabled,
        sortOrder: habit.sortOrder,
        isArchived: true,
        createdAt: habit.createdAt,
        updatedAt: DateTime.now(),
      );
      await _db.updateHabit(archived);
    }
  }

  /// Permanently delete a habit
  Future<void> deleteHabit(int id) async {
    // Delete all completions for this habit first
    final completions = await _db.getCompletionsForHabit(id);
    for (final c in completions) {
      await _db.deleteCompletion(c.id);
    }
    // Delete the habit
    await _db.deleteHabit(id);
  }

  /// Mark a habit as complete for today
  Future<void> completeHabit(int habitId, {String? note}) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Check if already completed today
    final existing = await _db.getCompletionForDate(habitId, today);

    if (existing != null) {
      // Increment count
      final updated = HabitCompletionEntity(
        id: existing.id,
        date: existing.date,
        habitId: existing.habitId,
        count: existing.count + 1,
        note: note ?? existing.note,
        completedAt: existing.completedAt,
      );
      await _db.updateCompletion(updated);
    } else {
      // Create new completion
      final completion = HabitCompletionsCompanion(
        habitId: Value(habitId),
        date: Value(today),
        count: const Value(1),
        note: Value(note),
        completedAt: Value(now),
      );
      await _db.insertCompletion(completion);
    }
  }

  /// Uncomplete a habit for today
  Future<void> uncompleteHabit(int habitId) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    await _db.deleteCompletionForDate(habitId, today);
  }

  /// Get completions for a habit in a date range
  Future<List<HabitCompletionModel>> getCompletionsForHabit(
    int habitId,
    DateTime start,
    DateTime end,
  ) async {
    final completions = await _db.getCompletionsForHabit(
      habitId,
      startDate: start,
      endDate: end,
    );
    return completions.map(_completionToModel).toList();
  }

  /// Get all completions for today
  Future<List<HabitCompletionModel>> getTodayCompletions() async {
    final completions = await _db.getTodayCompletions();
    return completions.map(_completionToModel).toList();
  }

  /// Calculate current streak for a habit
  Future<int> calculateStreak(int habitId) async {
    final now = DateTime.now();
    var currentDate = DateTime(now.year, now.month, now.day);
    var streak = 0;

    while (true) {
      final completion = await _db.getCompletionForDate(habitId, currentDate);

      if (completion == null) {
        // If today is not completed, check if yesterday was
        if (streak == 0) {
          currentDate = currentDate.subtract(const Duration(days: 1));
          continue;
        }
        break;
      }

      streak++;
      currentDate = currentDate.subtract(const Duration(days: 1));
    }

    return streak;
  }

  /// Get completion percentage for a habit in the current month
  Future<double> getMonthlyCompletionRate(int habitId) async {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0);

    final completions = await _db.getCompletionsForHabit(
      habitId,
      startDate: startOfMonth,
      endDate: endOfMonth,
    );

    final daysPassed = now.day;

    return completions.length / daysPassed * 100;
  }

  /// Watch all habits as a stream
  Stream<List<HabitModel>> watchAllHabits() {
    return _db.watchAllHabits().map((habits) => habits.map(_toModel).toList());
  }
}
