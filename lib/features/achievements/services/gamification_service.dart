import 'dart:math';
import 'package:drift/drift.dart';
import '../../../core/database/database.dart';
import '../../habits/data/models/habit.dart';
import '../../../core/models/priority_enum.dart';
import '../../habits/data/repositories/habit_repository.dart';
import '../data/badge_seeder.dart';
import '../data/models/achievement.dart';

/// Service responsible for handling Gamification logic,
/// including XP calculations, leveling systems, and progress tracking.
class GamificationService {
  final AppDatabase _db;
  final HabitRepository _habitRepository;

  const GamificationService(this._db, this._habitRepository);

  Future<void> initialize() async {
    await BadgeSeeder.seed(_db);
  }

  // Base XP gained for completing a single habit instance
  static const int _baseXp = 10;

  /// Calculates the XP earned for a habit completion.
  ///
  /// [priority] - The priority of the habit (determines multiplier).
  /// [currentStreak] - The current streak of the habit.
  ///
  /// Logic:
  /// - Base XP * Priority Multiplier
  /// - Streak Bonus: +5 XP for every 7 days of streak (capped at +50 XP)
  int calculateXpEarned({
    required HabitPriority priority,
    int currentStreak = 0,
  }) {
    // 1. Apply Priority Multiplier
    double rawXp = _baseXp * priority.xpMultiplier;

    // 2. Apply Streak Bonus
    // Rewards long-term consistency.
    // e.g., 7 days = +5, 14 days = +10, ..., 70 days = +50 (max)
    int streakBonus = (currentStreak ~/ 7) * 5;
    if (streakBonus > 50) streakBonus = 50;

    return rawXp.round() + streakBonus;
  }

  /// Calculates the user's level based on total XP.
  ///
  /// Formula: Level = floor(sqrt(TotalXP / 100)) + 1
  /// This creates a quadratic difficulty curve (levels get harder to reach).
  ///
  /// Examples:
  /// - 0 XP -> Level 1
  /// - 99 XP -> Level 1
  /// - 100 XP -> Level 2
  /// - 399 XP -> Level 2
  /// - 400 XP -> Level 3
  int calculateLevel(int totalXp) {
    if (totalXp < 0) return 1;
    return (sqrt(totalXp / 100)).floor() + 1;
  }

  /// Calculates the total XP required to reach the start of the NEXT level.
  ///
  /// Derived from the level formula:
  /// XP = 100 * (Level - 1)^2
  /// So for Next Level (L+1), required XP = 100 * L^2
  int xpForNextLevel(int currentLevel) {
    return 100 * (currentLevel * currentLevel);
  }

  /// Calculates the total XP required to reach the start of the CURRENT level.
  int xpForCurrentLevel(int currentLevel) {
    if (currentLevel <= 1) return 0;
    return 100 * ((currentLevel - 1) * (currentLevel - 1));
  }

  /// Calculates the progress percentage towards the next level (0.0 to 1.0).
  /// Useful for showing a progress bar.
  double progressToNextLevel(int totalXp) {
    int currentLevel = calculateLevel(totalXp);
    int startOfLevelXp = xpForCurrentLevel(currentLevel);
    int startOfNextLevelXp = xpForNextLevel(currentLevel);

    int xpInCurrentLevel = totalXp - startOfLevelXp;
    int xpRequiredForNextLevel = startOfNextLevelXp - startOfLevelXp;

    if (xpRequiredForNextLevel <= 0) return 1.0; // Fallback

    double progress = xpInCurrentLevel / xpRequiredForNextLevel;
    return progress.clamp(0.0, 1.0);
  }

  /// Adds XP for a completed habit.
  ///
  /// [habit] - The habit that was completed.
  /// [isStreakMaintain] - Whether the user maintained a streak.
  Future<void> addXPForHabit(HabitModel habit,
      {bool isStreakMaintain = false}) async {
    // 1. Calculate XP
    final currentStreak = await _habitRepository.calculateStreak(habit.id!);
    final earnedXp = calculateXpEarned(
      priority: HabitPriority.values.firstWhere(
        (e) => e.value == habit.priority,
        orElse: () => HabitPriority.medium,
      ),
      currentStreak: currentStreak,
    );

    // 2. Get User Progress
    final userProgress = await (_db.select(_db.userProgress).getSingleOrNull());
    UserProgressEntity updatedUserProgress;

    if (userProgress == null) {
      final xp = earnedXp;
      final lvl = calculateLevel(earnedXp);

      // Create initial progress if not exists
      await _db.into(_db.userProgress).insert(
            UserProgressCompanion.insert(
              xp: Value(xp),
              level: Value(lvl),
              joinDate: DateTime.now(),
              lastUpdated: DateTime.now(),
            ),
          );
      updatedUserProgress = await (_db.select(_db.userProgress).getSingle());
    } else {
      final newTotalXp = userProgress.xp + earnedXp;
      final newLevel = calculateLevel(newTotalXp);

      await (_db.update(_db.userProgress)
            ..where((u) => u.id.equals(userProgress.id)))
          .write(
        UserProgressCompanion(
            xp: Value(newTotalXp),
            level: Value(newLevel),
            lastUpdated: Value(DateTime.now())),
      );
      updatedUserProgress =
          userProgress.copyWith(xp: newTotalXp, level: newLevel);
    }

    // 3. Check for Achievements
    await checkAchievements(habit, currentStreak, updatedUserProgress);
  }

  /// Checks if any achievements should be unlocked based on the recent habit completion.
  Future<void> checkAchievements(HabitModel habit, int currentStreak,
      UserProgressEntity userProgress) async {
    final achievements = await _db.select(_db.achievements).get();

    for (final achievement in achievements) {
      // If already unlocked, skip unless we need to update progress (optional,
      // but for simplicity we skip logic if unlocked usually,
      // though updating progress for repeatable achievements might be desired in future)
      if (achievement.isUnlocked) continue;

      bool shouldUnlock = false;
      int newCurrentValue = achievement.currentValue;

      // Type: habitCount
      if (achievement.type == AchievementType.habitCount.index) {
        newCurrentValue++;
        if (newCurrentValue >= achievement.targetValue) {
          shouldUnlock = true;
        }
      }
      // Type: streak
      else if (achievement.type == AchievementType.streak.index) {
        if (currentStreak > newCurrentValue) {
          newCurrentValue = currentStreak;
        }
        if (newCurrentValue >= achievement.targetValue) {
          shouldUnlock = true;
        }
      }
      // Type: perfectDay (Early Bird)
      else if (achievement.type == AchievementType.perfectDay.index) {
        if (achievement.key == 'early_bird') {
          final now = DateTime.now();
          if (now.hour < 7) {
            shouldUnlock = true;
            newCurrentValue = 1;
          }
        }
      }
      // Type: milestone (Level)
      else if (achievement.type == AchievementType.milestone.index) {
        if (userProgress.level >= achievement.targetValue) {
          shouldUnlock = true;
          newCurrentValue = userProgress.level;
        } else {
          newCurrentValue = userProgress.level; // Update progress
        }
      }
      // Type: priority
      else if (achievement.type == AchievementType.priority.index) {
        // High (4) or Critical (5)
        if (habit.priority >= 4) {
          newCurrentValue++;
          if (newCurrentValue >= achievement.targetValue) {
            shouldUnlock = true;
          }
        }
      }

      // Update DB if changed
      if (shouldUnlock || newCurrentValue != achievement.currentValue) {
        await (_db.update(_db.achievements)
              ..where((a) => a.id.equals(achievement.id)))
            .write(AchievementsCompanion(
          currentValue: Value(newCurrentValue),
          isUnlocked: shouldUnlock ? const Value(true) : const Value(false),
          unlockedAt:
              shouldUnlock ? Value(DateTime.now()) : const Value.absent(),
        ));
      }
    }
  }
}
