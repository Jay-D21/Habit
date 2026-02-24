import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/achievements/services/gamification_service.dart';
import '../database/database.dart';
import 'habit_providers.dart';

/// Provider for the GamificationService
final gamificationServiceProvider = Provider<GamificationService>((ref) {
  final db = ref.watch(databaseProvider);
  final habitRepo = ref.watch(habitRepositoryProvider);
  return GamificationService(db, habitRepo);
});

/// Provider for User Progress (XP, Level)
final userProgressProvider = StreamProvider<UserProgressEntity?>((ref) {
  final db = ref.watch(databaseProvider);
  return db.select(db.userProgress).watchSingleOrNull();
});

/// Provider for Achievements
final achievementsProvider = StreamProvider<List<AchievementEntity>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.select(db.achievements).watch();
});
