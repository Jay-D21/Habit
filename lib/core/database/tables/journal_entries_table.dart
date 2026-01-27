import 'package:drift/drift.dart';

/// Journal entries table definition
@DataClassName('JournalEntryEntity')
class JournalEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 200)();
  TextColumn get content => text()();
  DateTimeColumn get date => dateTime()();
  IntColumn get mood => integer()(); // Enum as int
  TextColumn get tags => text().nullable()();
  TextColumn get voiceNotePath => text().nullable()();
  BoolColumn get hasVoiceNote => boolean().withDefault(const Constant(false))();
  IntColumn get wordCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}
