import 'package:flutter/material.dart';
import '../../data/models/achievement.dart';
import '../widgets/badge_item.dart';

class BadgesScreen extends StatelessWidget {
  const BadgesScreen({super.key});

  // Mock data for UI demonstration
  List<AchievementModel> get _mockAchievements => [
        AchievementModel(
          key: 'early_bird',
          name: 'Early Bird',
          description: 'Complete a habit before 7 AM',
          icon: '🌅',
          type: AchievementType.milestone,
          targetValue: 1,
          isUnlocked: true,
          unlockedAt: DateTime.now(),
        ),
        AchievementModel(
          key: 'week_streak',
          name: '7-Day Streak',
          description: 'Maintain a streak for 7 days',
          icon: '🔥',
          type: AchievementType.streak,
          targetValue: 7,
          currentValue: 5,
        ),
        AchievementModel(
          key: 'first_step',
          name: 'First Step',
          description: 'Complete your first habit',
          icon: '👣',
          type: AchievementType.habitCount,
          targetValue: 1,
          isUnlocked: true,
          unlockedAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
        AchievementModel(
          key: 'master',
          name: 'Habit Master',
          description: 'Reach Level 10',
          icon: '👑',
          type: AchievementType.milestone,
          targetValue: 10,
        ),
        AchievementModel(
          key: 'night_owl',
          name: 'Night Owl',
          description: 'Complete a habit after 10 PM',
          icon: '🦉',
          type: AchievementType.milestone,
          targetValue: 1,
        ),
        AchievementModel(
          key: 'century',
          name: 'Century Club',
          description: 'Complete 100 habits total',
          icon: '💯',
          type: AchievementType.totalCompletions,
          targetValue: 100,
          currentValue: 42,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final achievements = _mockAchievements;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Badges & Achievements',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // 3 columns
          childAspectRatio: 0.7, // Taller items
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: achievements.length,
        itemBuilder: (context, index) {
          return BadgeItem(achievement: achievements[index]);
        },
      ),
    );
  }
}
