import 'package:drift/drift.dart';

/// Diaries table definition
@DataClassName('DiaryEntity')
class Diaries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get description => text().nullable()();
  IntColumn get color => integer()();
  IntColumn get iconCodePoint => integer()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
}
