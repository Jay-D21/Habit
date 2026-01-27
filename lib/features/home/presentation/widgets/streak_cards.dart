import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../core/providers/habit_providers.dart';
import '../../../../core/providers/journal_providers.dart';

/// Streak cards showing habit, journal, and XP streaks
class StreakCards extends ConsumerWidget {
  const StreakCards({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overallStreakAsync = ref.watch(overallStreakProvider);
    final journalStreakAsync = ref.watch(journalStreakProvider);
    final todayProgress = ref.watch(todayProgressProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingLg,
        vertical: AppTheme.spacingMd,
      ),
      child: Row(
        children: [
          Expanded(
            child: _StreakCard(
              icon: '🔥',
              value: overallStreakAsync.when(
                data: (streak) => '$streak',
                loading: () => '-',
                error: (_, __) => '0',
              ),
              label: 'Day Streak',
              color: AppColors.accent,
            )
                .animate()
                .fadeIn(delay: 100.ms)
                .scale(begin: const Offset(0.95, 0.95)),
          ),
          const SizedBox(width: AppTheme.spacingMd),
          Expanded(
            child: _StreakCard(
              icon: '📝',
              value: journalStreakAsync.when(
                data: (streak) => '$streak',
                loading: () => '-',
                error: (_, __) => '0',
              ),
              label: 'Journal',
              color: AppColors.primary,
            )
                .animate()
                .fadeIn(delay: 200.ms)
                .scale(begin: const Offset(0.95, 0.95)),
          ),
          const SizedBox(width: AppTheme.spacingMd),
          Expanded(
            child: _StreakCard(
              icon: '📊',
              value: '${todayProgress.round()}%',
              label: 'Today',
              color: AppColors.success,
            )
                .animate()
                .fadeIn(delay: 300.ms)
                .scale(begin: const Offset(0.95, 0.95)),
          ),
        ],
      ),
    );
  }
}

class _StreakCard extends StatelessWidget {
  final String icon;
  final String value;
  final String label;
  final Color color;

  const _StreakCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.2 : 0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(icon, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: AppTheme.spacingXs),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}
