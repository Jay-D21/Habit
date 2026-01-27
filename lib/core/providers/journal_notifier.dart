import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../main.dart';
import '../../features/journal/data/models/journal_entry.dart';
import '../../core/database/database.dart';

/// Notifier for managing journal operations
class JournalNotifier extends Notifier<void> {
  @override
  void build() {}

  /// Create a new journal entry
  Future<int> createEntry({
    required String title,
    required String content,
    required Mood mood,
    List<String>? tags,
    String? voiceNotePath,
  }) async {
    final now = DateTime.now();
    final wordCount =
        content.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;

    final entry = JournalEntriesCompanion(
      title: drift.Value(title),
      content: drift.Value(content),
      date: drift.Value(DateTime(now.year, now.month, now.day)),
      mood: drift.Value(mood.index),
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
    required Mood mood,
    List<String>? tags,
  }) async {
    final existing = await database.getJournalEntryById(id);
    if (existing != null) {
      final wordCount =
          content.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;

      final updated = existing.copyWith(
        title: title,
        content: content,
        mood: mood.index,
        tags: drift.Value(tags?.join(',')),
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
