import 'package:drift/drift.dart';

/// Habits table definition
@DataClassName('HabitEntity')
class Habits extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get emoji => text().withLength(min: 1, max: 10)();
  IntColumn get category => integer()(); // Enum as int
  IntColumn get priority => integer().withDefault(
      const Constant(3))(); // Enum as int (HabitPriority), default Medium
  IntColumn get frequency => integer()(); // Enum as int
  TextColumn get customDays => text().nullable()();
  TextColumn get description => text().nullable()();
  TextColumn get colorHex => text().withLength(min: 6, max: 8)();
  IntColumn get targetCount => integer().withDefault(const Constant(1))();
  TextColumn get reminderTime => text().nullable()();
  BoolColumn get reminderEnabled =>
      boolean().withDefault(const Constant(false))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

/// Habit completions table definition
@DataClassName('HabitCompletionEntity')
class HabitCompletions extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  IntColumn get habitId => integer().references(Habits, #id)();
  IntColumn get count => integer().withDefault(const Constant(1))();
  TextColumn get note => text().nullable()();
  DateTimeColumn get completedAt => dateTime()();

  @override
  List<Set<Column>> get uniqueKeys => [
        {habitId, date},
      ];
}
