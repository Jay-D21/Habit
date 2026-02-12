import 'package:drift/drift.dart';
import '../../../../core/database/database.dart';
import 'models/achievement.dart';

class BadgeSeeder {
  static Future<void> seed(AppDatabase db) async {
    final count = await db.select(db.achievements).get().then((l) => l.length);
    if (count > 0) return;

    final badges = [
      AchievementsCompanion.insert(
        key: 'first_step',
        name: 'First Step',
        description: 'Complete your first habit to start the journey.',
        icon: '👣',
        type: AchievementType.habitCount.index,
        targetValue: 1,
        xpReward: const Value(50),
      ),
      AchievementsCompanion.insert(
        key: 'streak_3',
        name: 'Consistency Is Key',
        description: 'Maintain a 3-day streak on any habit.',
        icon: '🔥',
        type: AchievementType.streak.index,
        targetValue: 3,
        xpReward: const Value(100),
      ),
      AchievementsCompanion.insert(
        key: 'streak_7',
        name: 'Week Warrior',
        description: 'Maintain a 7-day streak. You are on fire!',
        icon: '📅',
        type: AchievementType.streak.index,
        targetValue: 7,
        xpReward: const Value(250),
      ),
      AchievementsCompanion.insert(
        key: 'early_bird',
        name: 'Early Bird',
        description: 'Complete a habit before 7 AM.',
        icon: '🌅',
        type: AchievementType.perfectDay.index, // Using perfectDay/time logic
        targetValue: 1,
        xpReward: const Value(150),
      ),
      AchievementsCompanion.insert(
        key: 'habit_master_10',
        name: 'Habit Master',
        description: 'Reach Level 10.',
        icon: '👑',
        type: AchievementType.milestone.index,
        targetValue: 10,
        xpReward: const Value(500),
      ),
      AchievementsCompanion.insert(
        key: 'priority_focus',
        name: 'Priority Focus',
        description: 'Complete 5 High Priority habits.',
        icon: '⭐',
        type: AchievementType.priority.index,
        targetValue: 5,
        xpReward: const Value(200),
      ),
    ];

    await db.batch((batch) {
      batch.insertAll(db.achievements, badges);
    });
  }
}
