/// Habit category enum
enum HabitCategory {
  health,
  mindfulness,
  fitness,
  learning,
  productivity,
  creativity,
  finance,
  personal,
}

/// Habit frequency enum
enum HabitFrequency {
  daily,
  weekdays,
  weekends,
  custom,
}

/// Habit model class (pure Dart, no Isar dependencies)
class HabitModel {
  final int? id;
  final String name;
  final String emoji;
  final HabitCategory category;
  final HabitFrequency frequency;
  final String? customDays;
  final String? description;
  final String colorHex;
  final int targetCount;
  final String? reminderTime;
  final bool reminderEnabled;
  final int priority;
  final int sortOrder;
  final bool isArchived;
  final bool isTimed;
  final int? timerDuration;
  final DateTime createdAt;
  final DateTime updatedAt;

  HabitModel({
    this.id,
    required this.name,
    required this.emoji,
    required this.category,
    required this.frequency,
    this.customDays,
    this.description,
    required this.colorHex,
    this.targetCount = 1,
    this.reminderTime,
    this.reminderEnabled = false,
    this.priority = 3, // Default medium
    this.sortOrder = 0,
    this.isArchived = false,
    this.isTimed = false,
    this.timerDuration,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Get custom days as list
  List<int> get customDaysList {
    if (customDays == null || customDays!.isEmpty) return [];
    return customDays!.split(',').map((e) => int.parse(e)).toList();
  }

  /// Create a copy with updated fields
  HabitModel copyWith({
    int? id,
    String? name,
    String? emoji,
    HabitCategory? category,
    HabitFrequency? frequency,
    String? customDays,
    String? description,
    String? colorHex,
    int? targetCount,
    String? reminderTime,
    bool? reminderEnabled,
    int? priority,
    int? sortOrder,
    bool? isArchived,
    bool? isTimed,
    int? timerDuration,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return HabitModel(
      id: id ?? this.id,
      name: name ?? this.name,
      emoji: emoji ?? this.emoji,
      category: category ?? this.category,
      frequency: frequency ?? this.frequency,
      customDays: customDays ?? this.customDays,
      description: description ?? this.description,
      colorHex: colorHex ?? this.colorHex,
      targetCount: targetCount ?? this.targetCount,
      reminderTime: reminderTime ?? this.reminderTime,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      priority: priority ?? this.priority,
      sortOrder: sortOrder ?? this.sortOrder,
      isArchived: isArchived ?? this.isArchived,
      isTimed: isTimed ?? this.isTimed,
      timerDuration: timerDuration ?? this.timerDuration,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// Habit completion model class
class HabitCompletionModel {
  final int? id;
  final DateTime date;
  final int habitId;
  final int count;
  final String? note;
  final DateTime completedAt;

  HabitCompletionModel({
    this.id,
    required this.date,
    required this.habitId,
    this.count = 1,
    this.note,
    required this.completedAt,
  });

  HabitCompletionModel copyWith({
    int? id,
    DateTime? date,
    int? habitId,
    int? count,
    String? note,
    DateTime? completedAt,
  }) {
    return HabitCompletionModel(
      id: id ?? this.id,
      date: date ?? this.date,
      habitId: habitId ?? this.habitId,
      count: count ?? this.count,
      note: note ?? this.note,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}

// Keep old class names for backward compatibility with existing code
// These are type aliases
typedef Habit = HabitModel;
typedef HabitCompletion = HabitCompletionModel;
