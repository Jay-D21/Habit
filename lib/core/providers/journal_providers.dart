import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../main.dart';
import '../../features/journal/data/models/journal_entry.dart';

/// Provider for all journal entries (sorted by date, newest first)
final journalEntriesProvider = StreamProvider<List<JournalEntryModel>>((ref) {
  return database.watchAllJournalEntries().map((entries) {
    return entries
        .map((e) => JournalEntryModel(
              id: e.id,
              title: e.title,
              content: e.content,
              date: e.date,
              mood: Mood.values[e.mood],
              tags: e.tags,
              voiceNotePath: e.voiceNotePath,
              hasVoiceNote: e.hasVoiceNote,
              wordCount: e.wordCount,
              createdAt: e.createdAt,
              updatedAt: e.updatedAt,
            ))
        .toList();
  });
});

/// Provider for a single journal entry by ID
final journalEntryProvider =
    FutureProvider.family<JournalEntryModel?, int>((ref, id) async {
  final entry = await database.getJournalEntryById(id);
  if (entry == null) return null;

  return JournalEntryModel(
    id: entry.id,
    title: entry.title,
    content: entry.content,
    date: entry.date,
    mood: Mood.values[entry.mood],
    tags: entry.tags,
    voiceNotePath: entry.voiceNotePath,
    hasVoiceNote: entry.hasVoiceNote,
    wordCount: entry.wordCount,
    createdAt: entry.createdAt,
    updatedAt: entry.updatedAt,
  );
});

/// Provider for journal entries count
final journalCountProvider = Provider<int>((ref) {
  final entriesAsync = ref.watch(journalEntriesProvider);

  return entriesAsync.when(
    data: (entries) => entries.length,
    loading: () => 0,
    error: (_, __) => 0,
  );
});

/// Provider for journal entries in the current month
final thisMonthJournalEntriesProvider =
    Provider<List<JournalEntryModel>>((ref) {
  final entriesAsync = ref.watch(journalEntriesProvider);
  final now = DateTime.now();
  final startOfMonth = DateTime(now.year, now.month, 1);

  return entriesAsync.when(
    data: (entries) =>
        entries.where((e) => e.date.isAfter(startOfMonth)).toList(),
    loading: () => [],
    error: (_, __) => [],
  );
});

/// Provider for journal streak
final journalStreakProvider = FutureProvider<int>((ref) async {
  final now = DateTime.now();
  var currentDate = DateTime(now.year, now.month, now.day);
  var streak = 0;

  while (true) {
    final entries = await database.getEntriesForDate(currentDate);

    if (entries.isEmpty) {
      if (streak == 0) {
        currentDate = currentDate.subtract(const Duration(days: 1));
        continue;
      }
      break;
    }

    streak++;
    currentDate = currentDate.subtract(const Duration(days: 1));

    // Safety limit
    if (streak > 365) break;
  }

  return streak;
});

/// Provider for entries grouped by date (for calendar view)
final journalEntriesByDateProvider =
    Provider<Map<DateTime, List<JournalEntryModel>>>((ref) {
  final entriesAsync = ref.watch(journalEntriesProvider);

  return entriesAsync.when(
    data: (entries) {
      final Map<DateTime, List<JournalEntryModel>> grouped = {};
      for (final entry in entries) {
        final date =
            DateTime(entry.date.year, entry.date.month, entry.date.day);
        grouped.putIfAbsent(date, () => []).add(entry);
      }
      return grouped;
    },
    loading: () => {},
    error: (_, __) => {},
  );
});
