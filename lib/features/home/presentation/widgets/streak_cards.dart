import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../core/providers/habit_providers.dart';
import '../../../../core/providers/journal_providers.dart';

/// Compact streak cards showing habit, journal, and XP streaks
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
              label: 'Streak',
              gradient: AppColors.accentGradient,
            )
                .animate()
                .fadeIn(delay: 100.ms)
                .scale(begin: const Offset(0.95, 0.95)),
          ),
          const SizedBox(width: AppTheme.spacingSm),
          Expanded(
            child: _StreakCard(
              icon: '📝',
              value: journalStreakAsync.when(
                data: (streak) => '$streak',
                loading: () => '-',
                error: (_, __) => '0',
              ),
              label: 'Journal',
              gradient: AppColors.primaryGradient,
            )
                .animate()
                .fadeIn(delay: 200.ms)
                .scale(begin: const Offset(0.95, 0.95)),
          ),
          const SizedBox(width: AppTheme.spacingSm),
          Expanded(
            child: _StreakCard(
              icon: '📊',
              value: '${todayProgress.round()}%',
              label: 'Today',
              gradient: AppColors.successGradient,
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
  final LinearGradient gradient;

  const _StreakCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppTheme.spacingSm,
        horizontal: AppTheme.spacingXs,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: gradient.begin,
          end: gradient.end,
          colors: gradient.colors
              .map((c) => c.withValues(alpha: isDark ? 0.25 : 0.12))
              .toList(),
        ),
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(
          color: gradient.colors.first.withValues(alpha: isDark ? 0.4 : 0.2),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(icon, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 2),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: gradient.colors.first,
            ),
          ),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
