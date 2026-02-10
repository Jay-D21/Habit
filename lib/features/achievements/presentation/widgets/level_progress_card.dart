import 'package:flutter/material.dart';
import '../../services/gamification_service.dart';

class LevelProgressCard extends StatelessWidget {
  final int currentXp;
  final GamificationService _gamificationService = GamificationService();

  LevelProgressCard({
    super.key,
    required this.currentXp,
  });

  @override
  Widget build(BuildContext context) {
    final int currentLevel = _gamificationService.calculateLevel(currentXp);
    final double progress = _gamificationService.progressToNextLevel(currentXp);
    final int xpForCurrent =
        _gamificationService.xpForCurrentLevel(currentLevel);
    final int xpForNext = _gamificationService.xpForNextLevel(currentLevel);

    // XP gained within this level
    final int currentLevelXp = currentXp - xpForCurrent;
    // Total XP needed for this level
    final int levelRange = xpForNext - xpForCurrent;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [
              Color(0xFF6200EA),
              Color(0xFFB388FF)
            ], // Deep Purple to Light Purple
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'LEVEL $currentLevel',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Habit Master', // Placeholder title
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.emoji_events_rounded,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$currentLevelXp / $levelRange XP',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
                Text(
                  '${(progress * 100).toInt()}%',
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 12,
                backgroundColor: Colors.black12,
                valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFF00E5FF)), // Cyan accent
              ),
            ),
          ],
        ),
      ),
    );
  }
}
