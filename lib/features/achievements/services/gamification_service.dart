import 'dart:math';
import '../../../core/models/priority_enum.dart';

/// Service responsible for handling Gamification logic,
/// including XP calculations, leveling systems, and progress tracking.
class GamificationService {
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
}
