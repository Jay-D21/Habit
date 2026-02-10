import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'habit_providers.dart';
import '../../core/database/database.dart';

/// Provider for user progress (XP, Level)
final userProgressProvider = StreamProvider<UserProgressEntity?>((ref) async* {
  final db = ref.watch(databaseProvider);

  // Create a stream that emits whenever userProgress table updates
  // Since we don't have a specific table watcher for single row easily exposed in AppDatabase without custom query,
  // we can watch the whole table select.
  final stream = db.select(db.userProgress).watchSingleOrNull();

  await for (final progress in stream) {
    yield progress;
  }
});
