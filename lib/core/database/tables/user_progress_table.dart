import 'package:drift/drift.dart';

/// User progress table definition for Gamification
@DataClassName('UserProgressEntity')
class UserProgress extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get email => text().nullable()();
  IntColumn get xp => integer().withDefault(const Constant(0))();
  IntColumn get level => integer().withDefault(const Constant(1))();
  DateTimeColumn get joinDate => dateTime()();
  DateTimeColumn get lastUpdated => dateTime()();
}
