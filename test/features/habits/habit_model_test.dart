import 'package:flutter_test/flutter_test.dart';
import 'package:habit_tracker/features/habits/data/models/habit.dart';

void main() {
  group('HabitModel', () {
    test('should create a valid instance with defaults', () {
      final now = DateTime.now();
      final habit = HabitModel(
        id: 1,
        name: 'Test Habit',
        emoji: '🧪',
        category: HabitCategory.productivity,
        frequency: HabitFrequency.daily,
        colorHex: 'FF000000',
        createdAt: now,
        updatedAt: now,
      );

      expect(habit.id, 1);
      expect(habit.name, 'Test Habit');
      expect(habit.emoji, '🧪');
      expect(habit.targetCount, 1); // Default value
      expect(habit.reminderEnabled, false); // Default value
      expect(habit.sortOrder, 0); // Default value
      expect(habit.isArchived, false); // Default value
    });

    test('copyWith should update fields', () {
      final now = DateTime.now();
      final habit = HabitModel(
        id: 1,
        name: 'Test Habit',
        emoji: '🧪',
        category: HabitCategory.productivity,
        frequency: HabitFrequency.daily,
        colorHex: 'FF000000',
        createdAt: now,
        updatedAt: now,
      );

      final updated = habit.copyWith(
        name: 'Updated Name',
        targetCount: 5,
      );

      expect(updated.name, 'Updated Name');
      expect(updated.targetCount, 5);
      expect(updated.emoji, habit.emoji); // Unchanged
      expect(updated.id, habit.id); // Unchanged
    });
  });
}
