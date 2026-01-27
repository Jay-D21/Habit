/// Achievement types
enum AchievementType {
  streak, // Streak-based achievements
  habitCount, // Number of habits completed
  journalCount, // Number of journal entries
  perfectDay, // Perfect day achievements
  totalCompletions, // Total habit completions
  milestone, // Milestone achievements
}

/// Achievement model class (pure Dart, no Isar dependencies)
class AchievementModel {
  final int? id;
  final String key;
  final String name;
  final String description;
  final String icon;
  final AchievementType type;
  final int targetValue;
  final int currentValue;
  final int xpReward;
  final bool isUnlocked;
  final DateTime? unlockedAt;

  AchievementModel({
    this.id,
    required this.key,
    required this.name,
    required this.description,
    required this.icon,
    required this.type,
    required this.targetValue,
    this.currentValue = 0,
    this.xpReward = 0,
    this.isUnlocked = false,
    this.unlockedAt,
  });

  /// Progress percentage (0-100)
  double get progress {
    if (targetValue == 0) return 0;
    return (currentValue / targetValue * 100).clamp(0, 100);
  }

  /// Check if achievement is complete
  bool get isComplete => currentValue >= targetValue;

  /// Create a copy with updated fields
  AchievementModel copyWith({
    int? id,
    String? key,
    String? name,
    String? description,
    String? icon,
    AchievementType? type,
    int? targetValue,
    int? currentValue,
    int? xpReward,
    bool? isUnlocked,
    DateTime? unlockedAt,
  }) {
    return AchievementModel(
      id: id ?? this.id,
      key: key ?? this.key,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      type: type ?? this.type,
      targetValue: targetValue ?? this.targetValue,
      currentValue: currentValue ?? this.currentValue,
      xpReward: xpReward ?? this.xpReward,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
    );
  }
}

// Keep old class name for backward compatibility
typedef Achievement = AchievementModel;
