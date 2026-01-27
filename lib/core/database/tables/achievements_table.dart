import 'package:drift/drift.dart';

/// Achievements table definition
@DataClassName('AchievementEntity')
class Achievements extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get key => text().unique()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get description => text()();
  TextColumn get icon => text()();
  IntColumn get type => integer()(); // Enum as int
  IntColumn get targetValue => integer()();
  IntColumn get currentValue => integer().withDefault(const Constant(0))();
  IntColumn get xpReward => integer().withDefault(const Constant(0))();
  BoolColumn get isUnlocked => boolean().withDefault(const Constant(false))();
  DateTimeColumn get unlockedAt => dateTime().nullable()();
}
