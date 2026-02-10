import 'package:drift/drift.dart';
import '../../../core/database/database.dart';
import '../data/models/achievement.dart';

class AchievementService {
  final AppDatabase _db;

  AchievementService(this._db);

  /// Initialize default achievements if the table is empty
  Future<void> initializeDefaultAchievements() async {
    final existing = await _db.getAllAchievements();
    if (existing.isNotEmpty) return;

    final defaults = [
      AchievementsCompanion(
        key: const Value('first_step'),
        name: const Value('First Step'),
        description: const Value('Complete your first habit'),
        icon: const Value('👣'),
        type: Value(AchievementType.habitCount.index),
        targetValue: const Value(1),
        xpReward: const Value(10),
      ),
      AchievementsCompanion(
        key: const Value('week_streak'),
        name: const Value('7-Day Streak'),
        description: const Value('Maintain a streak for 7 days'),
        icon: const Value('🔥'),
        type: Value(AchievementType.streak.index),
        targetValue: const Value(7),
        xpReward: const Value(50),
      ),
      AchievementsCompanion(
        key: const Value('early_bird'),
        name: const Value('Early Bird'),
        description: const Value('Complete a habit before 7 AM'),
        icon: const Value('🌅'),
        type: Value(
            AchievementType.milestone.index), // Assuming milestone for now
        targetValue: const Value(1),
        xpReward: const Value(20),
      ),
      AchievementsCompanion(
        key: const Value('century_club'),
        name: const Value('Century Club'),
        description: const Value('Complete 100 habits total'),
        icon: const Value('💯'),
        type: Value(AchievementType.totalCompletions.index),
        targetValue: const Value(100),
        xpReward: const Value(100),
      ),
      AchievementsCompanion(
        key: const Value('habit_master'),
        name: const Value('Habit Master'),
        description: const Value('Reach Level 10'),
        icon: const Value('👑'),
        type: Value(AchievementType.milestone.index),
        targetValue: const Value(10),
        xpReward: const Value(500),
      ),
    ];

    for (var achievement in defaults) {
      await _db.insertAchievement(achievement);
    }
  }

  /// Get all achievements
  Future<List<AchievementEntity>> getAchievements() {
    return _db.getAllAchievements();
  }

  /// Check and unlock achievements based on type and value
  /// Returns a list of newly unlocked achievements
  Future<List<AchievementEntity>> checkAndUnlock({
    required AchievementType type,
    required int currentValue,
    String? specificKey, // For specific achievements like "early_bird"
  }) async {
    // Get all achievements of this type
    // Note: Drift doesn't support complex enum filtering easily on generic queries
    // without converters, so fetching all might be safer for now or filtering in memory
    // if dataset is small (achievements are usually few).
    // Or we can add a specialized query in DB, but let's do in-memory for MVP.

    final allAchievements = await _db.getAllAchievements();
    final newlyUnlocked = <AchievementEntity>[];

    for (var achievement in allAchievements) {
      // 1. Skip if already unlocked
      if (achievement.isUnlocked) continue;

      // 2. Filter by type
      if (achievement.type != type.index) continue;

      // 3. Filter by key if specified
      if (specificKey != null && achievement.key != specificKey) continue;

      // 4. Check condition
      if (currentValue >= achievement.targetValue) {
        // Unlock!
        final updated = achievement.copyWith(
          isUnlocked: true,
          unlockedAt: Value(DateTime.now()),
          currentValue: currentValue, // Update to current
        );

        await _db.updateAchievement(updated);
        newlyUnlocked.add(updated);
      } else {
        // Update progress but don't unlock
        if (achievement.currentValue != currentValue) {
          final updated = achievement.copyWith(
            currentValue: currentValue,
          );
          await _db.updateAchievement(updated);
        }
      }
    }

    return newlyUnlocked;
  }

  /// Helper to update progress without unlocking (unless threshold met)
  /// useful for incremental updates like "Total Completions"
  Future<void> updateProgress(AchievementType type, int amountToAdd) async {
    final allAchievements = await _db.getAllAchievements();

    for (var achievement in allAchievements) {
      if (achievement.isUnlocked) continue;
      if (achievement.type != type.index) continue;

      int newValue = achievement.currentValue + amountToAdd;

      if (newValue >= achievement.targetValue) {
        final updated = achievement.copyWith(
          isUnlocked: true,
          unlockedAt: Value(DateTime.now()),
          currentValue: newValue,
        );
        await _db.updateAchievement(updated);
      } else {
        final updated = achievement.copyWith(
          currentValue: newValue,
        );
        await _db.updateAchievement(updated);
      }
    }
  }
}
