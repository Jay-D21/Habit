import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'habit_providers.dart';
import '../../core/database/database.dart';
import '../../features/achievements/services/gamification_service.dart';

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

/// Provider for all achievements
final achievementsProvider = StreamProvider<List<AchievementEntity>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.select(db.achievements).watch();
});

/// Provider for GamificationService
final gamificationServiceProvider = Provider<GamificationService>((ref) {
  final db = ref.watch(databaseProvider);
  final habitRepo = ref.watch(habitRepositoryProvider);
  return GamificationService(db, habitRepo);
});
