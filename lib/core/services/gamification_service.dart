import 'package:drift/drift.dart';
import '../database/database.dart';
import '../../features/habits/data/models/habit.dart';

class GamificationService {
  final AppDatabase _db;

  // Constants for XP calculation
  static const int baseXP = 10;
  static const int streakBonusXP = 5;
  static const int maxLevel = 100;

  GamificationService(this._db);

  /// Calculate XP required for next level
  /// Formula: level * 100 * (level / 2)
  int xpForLevel(int level) {
    if (level >= maxLevel) return -1; // Max level reached
    return (level * 100 * (1 + (level * 0.1))).round();
  }

  /// Add XP for completing a habit
  /// Returns a tuple of (xpAdded, didLevelUp, newLevel)
  Future<(int, bool, int)> addXPForHabit(HabitModel habit,
      {bool isStreakMaintain = false}) async {
    int xpToAdd = _calculateXP(habit, isStreakMaintain: isStreakMaintain);

    final userProgress = await _db.getUserProgress();
    var currentXP = 0;
    var currentLevel = 1;
    UserProgressEntity? entity = userProgress;

    if (userProgress == null) {
      // First time, create entry
      final now = DateTime.now();
      await _db.insertUserProgress(UserProgressCompanion(
        xp: const Value(0),
        level: const Value(1),
        joinDate: Value(now),
        lastUpdated: Value(now),
      ));
      entity = await _db.getUserProgress();
    }

    if (entity != null) {
      currentXP = entity.xp;
      currentLevel = entity.level;
    }

    final newXP = currentXP + xpToAdd;
    var newLevel = currentLevel;
    var didLevelUp = false;

    // Check for level up
    while (true) {
      final requiredXP = xpForLevel(newLevel);
      if (requiredXP != -1 && newXP >= requiredXP) {
        newLevel++;
        didLevelUp = true;
      } else {
        break;
      }
    }

    if (entity != null) {
      await _db.updateUserProgress(entity.copyWith(
        xp: newXP,
        level: newLevel,
        lastUpdated: DateTime.now(),
      ));
    }

    return (xpToAdd, didLevelUp, newLevel);
  }

  /// Calculate XP based on habit priority and streaks
  int _calculateXP(HabitModel habit, {bool isStreakMaintain = false}) {
    double multiplier = 1.0;

    // Priority Multiplier
    // 5=Critical(2.5x), 4=High(2.0x), 3=Medium(1.5x), 2=Low(1.2x), 1=Minimal(1.0x)
    switch (habit.priority) {
      case 5:
        multiplier = 2.5;
        break;
      case 4:
        multiplier = 2.0;
        break;
      case 3:
        multiplier = 1.5;
        break;
      case 2:
        multiplier = 1.2;
        break;
      default:
        multiplier = 1.0;
    }

    int xp = (baseXP * multiplier).round();

    if (isStreakMaintain) {
      xp += streakBonusXP;
    }

    return xp;
  }

  /// Get current user progress
  Future<UserProgressEntity?> getUserProgress() async {
    return _db.getUserProgress();
  }
}
