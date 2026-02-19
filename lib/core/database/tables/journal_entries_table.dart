import 'package:drift/drift.dart';
import 'diaries_table.dart';

/// Journal entries table definition
@DataClassName('JournalEntryEntity')
class JournalEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 200)();
  TextColumn get content => text()();
  DateTimeColumn get date => dateTime()();
  IntColumn get diaryId => integer().nullable().references(Diaries,
      #id)(); // Nullable for migration, but ideally references a default diary
  IntColumn get iconCodePoint => integer().nullable()();
  IntColumn get iconColor => integer().nullable()();

  // Deprecated/Legacy
  IntColumn get mood => integer().withDefault(const Constant(0))();

  TextColumn get tags => text().nullable()();
  TextColumn get voiceNotePath => text().nullable()();
  BoolColumn get hasVoiceNote => boolean().withDefault(const Constant(false))();
  IntColumn get wordCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}
