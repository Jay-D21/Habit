import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../main.dart';
import '../../features/journal/data/models/journal_entry.dart';
import '../../core/database/database.dart';

/// Notifier for managing journal operations
class JournalNotifier extends Notifier<void> {
  @override
  void build() {}

  // ================= DIOARY OPERATIONS =================

  /// Create a new diary
  Future<int> createDiary({
    required String name,
    String? description,
    required int color,
    required int iconCodePoint,
  }) async {
    final now = DateTime.now();
    final diary = DiariesCompanion(
      name: drift.Value(name),
      description: drift.Value(description),
      color: drift.Value(color),
      iconCodePoint: drift.Value(iconCodePoint),
      createdAt: drift.Value(now),
    );
    return await database.into(database.diaries).insert(diary);
  }

  /// Update a diary
  Future<bool> updateDiary(DiaryEntity diary) async {
    return await database.update(database.diaries).replace(diary);
  }

  /// Delete a diary
  Future<int> deleteDiary(int id) async {
    return await (database.delete(database.diaries)
          ..where((d) => d.id.equals(id)))
        .go();
  }

  // ================= ENTRY OPERATIONS =================

  /// Create a new journal entry
  Future<int> createEntry({
    required int diaryId,
    required String title,
    required String content,
    required DateTime date,
    int? iconCodePoint,
    int? iconColor,
    Mood? mood, // Keep optional for legacy/fallback
    List<String>? tags,
    String? voiceNotePath,
  }) async {
    final now = DateTime.now();
    final wordCount =
        content.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;

    final entry = JournalEntriesCompanion(
      diaryId: drift.Value(diaryId),
      title: drift.Value(title),
      content: drift.Value(content),
      date: drift.Value(DateTime(date.year, date.month, date.day)),
      mood: drift.Value(mood?.index ?? 0),
      iconCodePoint: drift.Value(iconCodePoint),
      iconColor: drift.Value(iconColor),
      tags: drift.Value(tags?.join(',')),
      voiceNotePath: drift.Value(voiceNotePath),
      hasVoiceNote: drift.Value(voiceNotePath != null),
      wordCount: drift.Value(wordCount),
      createdAt: drift.Value(now),
      updatedAt: drift.Value(now),
    );

    return await database.insertJournalEntry(entry);
  }

  /// Update an existing journal entry
  Future<void> updateEntry({
    required int id,
    required String title,
    required String content,
    required DateTime date,
    int? iconCodePoint,
    int? iconColor,
    Mood? mood,
    List<String>? tags,
    String? voiceNotePath,
  }) async {
    final existing = await database.getJournalEntryById(id);
    if (existing != null) {
      final wordCount =
          content.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;

      final updated = existing.copyWith(
        title: title,
        content: content,
        date: DateTime(date.year, date.month, date.day),
        mood: mood?.index ?? existing.mood,
        iconCodePoint: drift.Value(iconCodePoint),
        iconColor: drift.Value(iconColor),
        tags: drift.Value(tags?.join(',')),
        voiceNotePath: drift.Value(voiceNotePath),
        hasVoiceNote: voiceNotePath != null,
        wordCount: wordCount,
        updatedAt: DateTime.now(),
      );

      await database.updateJournalEntry(updated);
    }
  }

  /// Delete a journal entry
  Future<void> deleteEntry(int id) async {
    await database.deleteJournalEntry(id);
  }
}

/// Provider for journal operations
final journalNotifierProvider = NotifierProvider<JournalNotifier, void>(() {
  return JournalNotifier();
});
