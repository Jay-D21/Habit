import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/gamification_providers.dart';
import '../../data/models/achievement.dart'; // Keep for AchievementType if needed
import '../widgets/badge_item.dart';

class BadgesScreen extends ConsumerWidget {
  const BadgesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final achievementsAsync = ref.watch(achievementsProvider);

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
      body: achievementsAsync.when(
        data: (achievements) {
          if (achievements.isEmpty) {
            return const Center(child: Text('No achievements yet.'));
          }
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.7,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: achievements.length,
            itemBuilder: (context, index) {
              final entity = achievements[index];
              // map entity to model for BadgeItem
              final model = AchievementModel(
                id: entity.id,
                key: entity.key,
                name: entity.name,
                description: entity.description,
                icon: entity.icon,
                type: AchievementType.values[entity.type], // int to enum
                targetValue: entity.targetValue,
                currentValue: entity.currentValue,
                xpReward: entity.xpReward,
                isUnlocked: entity.isUnlocked,
                unlockedAt: entity.unlockedAt,
              );
              return BadgeItem(achievement: model);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
