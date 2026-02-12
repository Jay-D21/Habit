import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'package:habit_tracker/core/database/tables/habits_table.dart';
import 'package:habit_tracker/core/database/tables/journal_entries_table.dart';
import 'package:habit_tracker/core/database/tables/achievements_table.dart';
import 'package:habit_tracker/core/database/tables/user_progress_table.dart';
import 'package:habit_tracker/core/database/tables/focus_settings_table.dart';

part 'database.g.dart';

@DriftDatabase(tables: [
  Habits,
  HabitCompletions,
  JournalEntries,
  Achievements,
  UserProgress,
  FocusSettings, // Add table
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 4; // Increment version

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) => m.createAll(),
        onUpgrade: (Migrator m, int from, int to) async {
          if (from < 2) {
            await m.addColumn(habits, habits.priority);
          }
          if (from < 3) {
            await m.createTable(userProgress);
          }
          if (from < 4) {
            // Add FocusSettings table
            await m.createTable(focusSettings);
            // Insert default settings
            await into(focusSettings).insert(
              const FocusSettingsCompanion(), // Uses defaults
            );
          }
        },
      );

  // ============ FOCUS SETTINGS QUERIES ============

  /// Get focus settings (first row)
  Future<FocusSettingsData?> getFocusSettings() {
    return select(focusSettings).getSingleOrNull();
  }

  /// Update focus settings
  Future<int> updateFocusSettings(FocusSettingsCompanion settings) {
    // We update the row with ID 1, or insert if not exists
    return into(focusSettings).insertOnConflictUpdate(settings);
  }

  // ============ HABIT QUERIES ============

  /// Get all habits (non-archived)
  Future<List<HabitEntity>> getAllHabits() {
    return (select(habits)
          ..where((h) => h.isArchived.equals(false))
          ..orderBy([(h) => OrderingTerm.asc(h.sortOrder)]))
        .get();
  }

  /// Get habit by ID
  Future<HabitEntity?> getHabitById(int id) {
    return (select(habits)..where((h) => h.id.equals(id))).getSingleOrNull();
  }

  /// Insert a new habit
  Future<int> insertHabit(HabitsCompanion habit) {
    return into(habits).insert(habit);
  }

  /// Update a habit
  Future<bool> updateHabit(HabitEntity habit) {
    return update(habits).replace(habit);
  }

  /// Delete a habit
  Future<int> deleteHabit(int id) {
    return (delete(habits)..where((h) => h.id.equals(id))).go();
  }

  /// Watch all habits (stream)
  Stream<List<HabitEntity>> watchAllHabits() {
    return (select(habits)
          ..where((h) => h.isArchived.equals(false))
          ..orderBy([(h) => OrderingTerm.asc(h.sortOrder)]))
        .watch();
  }

  // ============ HABIT COMPLETION QUERIES ============

  /// Get completions for a specific habit and date range
  Future<List<HabitCompletionEntity>> getCompletionsForHabit(
    int habitId, {
    DateTime? startDate,
    DateTime? endDate,
  }) {
    var query = select(habitCompletions)
      ..where((c) => c.habitId.equals(habitId));

    if (startDate != null) {
      query = query..where((c) => c.date.isBiggerOrEqualValue(startDate));
    }
    if (endDate != null) {
      query = query..where((c) => c.date.isSmallerOrEqualValue(endDate));
    }

    return query.get();
  }

  /// Get completion for specific habit and date
  Future<HabitCompletionEntity?> getCompletionForDate(
      int habitId, DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return (select(habitCompletions)
          ..where((c) => c.habitId.equals(habitId))
          ..where((c) => c.date.isBiggerOrEqualValue(startOfDay))
          ..where((c) => c.date.isSmallerThanValue(endOfDay)))
        .getSingleOrNull();
  }

  /// Insert a completion
  Future<int> insertCompletion(HabitCompletionsCompanion completion) {
    return into(habitCompletions).insert(completion);
  }

  /// Update a completion
  Future<bool> updateCompletion(HabitCompletionEntity completion) {
    return update(habitCompletions).replace(completion);
  }

  /// Delete a completion
  Future<int> deleteCompletion(int id) {
    return (delete(habitCompletions)..where((c) => c.id.equals(id))).go();
  }

  /// Delete completions for a habit on a date
  Future<int> deleteCompletionForDate(int habitId, DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return (delete(habitCompletions)
          ..where((c) => c.habitId.equals(habitId))
          ..where((c) => c.date.isBiggerOrEqualValue(startOfDay))
          ..where((c) => c.date.isSmallerThanValue(endOfDay)))
        .go();
  }

  /// Get all completions for today
  Future<List<HabitCompletionEntity>> getTodayCompletions() {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return (select(habitCompletions)
          ..where((c) => c.date.isBiggerOrEqualValue(startOfDay))
          ..where((c) => c.date.isSmallerThanValue(endOfDay)))
        .get();
  }

  // ============ JOURNAL ENTRY QUERIES ============

  /// Get all journal entries
  Future<List<JournalEntryEntity>> getAllJournalEntries() {
    return (select(journalEntries)..orderBy([(e) => OrderingTerm.desc(e.date)]))
        .get();
  }

  /// Get journal entry by ID
  Future<JournalEntryEntity?> getJournalEntryById(int id) {
    return (select(journalEntries)..where((e) => e.id.equals(id)))
        .getSingleOrNull();
  }

  /// Get entries for a specific date
  Future<List<JournalEntryEntity>> getEntriesForDate(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return (select(journalEntries)
          ..where((e) => e.date.isBiggerOrEqualValue(startOfDay))
          ..where((e) => e.date.isSmallerThanValue(endOfDay)))
        .get();
  }

  /// Insert a journal entry
  Future<int> insertJournalEntry(JournalEntriesCompanion entry) {
    return into(journalEntries).insert(entry);
  }

  /// Update a journal entry
  Future<bool> updateJournalEntry(JournalEntryEntity entry) {
    return update(journalEntries).replace(entry);
  }

  /// Delete a journal entry
  Future<int> deleteJournalEntry(int id) {
    return (delete(journalEntries)..where((e) => e.id.equals(id))).go();
  }

  /// Watch all journal entries
  Stream<List<JournalEntryEntity>> watchAllJournalEntries() {
    return (select(journalEntries)..orderBy([(e) => OrderingTerm.desc(e.date)]))
        .watch();
  }

  // ============ ACHIEVEMENT QUERIES ============

  /// Get all achievements
  Future<List<AchievementEntity>> getAllAchievements() {
    return select(achievements).get();
  }

  /// Get achievement by key
  Future<AchievementEntity?> getAchievementByKey(String key) {
    return (select(achievements)..where((a) => a.key.equals(key)))
        .getSingleOrNull();
  }

  /// Insert an achievement
  Future<int> insertAchievement(AchievementsCompanion achievement) {
    return into(achievements).insert(achievement);
  }

  /// Update an achievement
  Future<bool> updateAchievement(AchievementEntity achievement) {
    return update(achievements).replace(achievement);
  }

  /// Get unlocked achievements
  Future<List<AchievementEntity>> getUnlockedAchievements() {
    return (select(achievements)..where((a) => a.isUnlocked.equals(true)))
        .get();
  }

  // ============ USER PROGRESS QUERIES ============

  /// Get user progress (should only be one entry usually)
  Future<UserProgressEntity?> getUserProgress() {
    return select(userProgress).getSingleOrNull();
  }

  /// Insert user progress
  Future<int> insertUserProgress(UserProgressCompanion progress) {
    return into(userProgress).insert(progress);
  }

  /// Update user progress
  Future<bool> updateUserProgress(UserProgressEntity progress) {
    return update(userProgress).replace(progress);
  }
}

/// Opens the database connection
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'habit_tracker.db'));

    if (kDebugMode) {
      debugPrint('Database path: ${file.path}');
    }

    return NativeDatabase.createInBackground(file);
  });
}
