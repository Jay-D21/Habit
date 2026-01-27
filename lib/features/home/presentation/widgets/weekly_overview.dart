import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:drift/drift.dart' as drift;
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../core/providers/habit_providers.dart';
import '../../../../main.dart'; // database

/// Stream watcher for habit completions to trigger refresh
final _weeklyCompletionsWatchProvider = StreamProvider((ref) {
  return database.select(database.habitCompletions).watch();
});

/// Provider for weekly completion data (real database data)
final weeklyCompletionProvider =
    FutureProvider<Map<DateTime, double>>((ref) async {
  // Watch for changes to refresh automatically
  ref.watch(_weeklyCompletionsWatchProvider);
  ref.watch(habitsProvider);

  final now = DateTime.now();
  final startOfWeek =
      DateTime(now.year, now.month, now.day - (now.weekday - 1));
  final Map<DateTime, double> weekData = {};

  // Get all active habits
  final habits = await database.getAllHabits();
  if (habits.isEmpty) {
    // Return all days as 0 progress
    for (int i = 0; i < 7; i++) {
      final date =
          DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day + i);
      weekData[date] = 0;
    }
    return weekData;
  }

  // Get completions for the week in one query
  final endOfWeek = startOfWeek.add(const Duration(days: 7));
  final completions = await (database.select(database.habitCompletions)
        ..where((c) => c.date.isBiggerOrEqualValue(startOfWeek))
        ..where((c) => c.date.isSmallerThanValue(endOfWeek)))
      .get();

  // For each day of the week
  for (int i = 0; i < 7; i++) {
    final date =
        DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day + i);

    // Filter completions for this date
    final dailyCompletions = completions
        .where((c) =>
            c.date.year == date.year &&
            c.date.month == date.month &&
            c.date.day == date.day)
        .toList();

    // Calculate progress as percentage of habits completed
    final completedHabitIds = dailyCompletions.map((c) => c.habitId).toSet();
    final progress = (completedHabitIds.length / habits.length) * 100;
    weekData[date] = progress;
  }

  return weekData;
});

/// Weekly overview showing habit completion for each day
class WeeklyOverview extends ConsumerWidget {
  const WeeklyOverview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final weeklyDataAsync = ref.watch(weeklyCompletionProvider);

    // Get current week days
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final weekDays =
        List.generate(7, (i) => startOfWeek.add(Duration(days: i)));

    return Padding(
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacingLg),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Weekly Overview',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppTheme.spacingLg),
            weeklyDataAsync.when(
              data: (weekData) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: weekDays.map((date) {
                  final isToday = _isSameDay(date, now);
                  final isFuture = date.isAfter(now);
                  final normalizedDate =
                      DateTime(date.year, date.month, date.day);
                  final progress = weekData[normalizedDate] ?? 0;

                  return _DayIndicator(
                    dayName: DateFormat('E').format(date).substring(0, 1),
                    isToday: isToday,
                    isFuture: isFuture,
                    progress: progress,
                  );
                }).toList(),
              ),
              loading: () => const Center(
                child: SizedBox(
                  height: 50,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
              error: (e, _) => Text('Error: $e'),
            ),
            const SizedBox(height: AppTheme.spacingMd),

            // Legend
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const _LegendItem(color: AppColors.success, label: 'Complete'),
                const SizedBox(width: AppTheme.spacingLg),
                const _LegendItem(color: AppColors.warning, label: 'Partial'),
                const SizedBox(width: AppTheme.spacingLg),
                _LegendItem(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
                  label: 'Missed',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

class _DayIndicator extends StatelessWidget {
  final String dayName;
  final bool isToday;
  final bool isFuture;
  final double progress;

  const _DayIndicator({
    required this.dayName,
    required this.isToday,
    required this.isFuture,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final status = isFuture
        ? _CompletionStatus.future
        : progress >= 100
            ? _CompletionStatus.complete
            : progress > 0
                ? _CompletionStatus.partial
                : _CompletionStatus.missed;

    return Column(
      children: [
        Text(
          dayName,
          style: theme.textTheme.labelSmall?.copyWith(
            color: isToday
                ? AppColors.primary
                : theme.colorScheme.onSurface.withValues(alpha: 0.5),
            fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        const SizedBox(height: AppTheme.spacingSm),
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: _getStatusColor(context, status),
            shape: BoxShape.circle,
            border:
                isToday ? Border.all(color: AppColors.primary, width: 2) : null,
          ),
          child: status == _CompletionStatus.complete
              ? const Icon(
                  Icons.check_rounded,
                  size: 18,
                  color: Colors.white,
                )
              : null,
        ),
      ],
    );
  }

  Color _getStatusColor(BuildContext context, _CompletionStatus status) {
    switch (status) {
      case _CompletionStatus.complete:
        return AppColors.success;
      case _CompletionStatus.partial:
        return AppColors.warning;
      case _CompletionStatus.missed:
        return Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.2);
      case _CompletionStatus.future:
        return Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1);
    }
  }
}

enum _CompletionStatus { complete, partial, missed, future }

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: AppTheme.spacingXs),
        Text(
          label,
          style: theme.textTheme.labelSmall,
        ),
      ],
    );
  }
}
