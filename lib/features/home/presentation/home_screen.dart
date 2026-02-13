import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/providers/habit_providers.dart';
import '../../../core/providers/habit_notifier.dart';
import '../../../core/services/ad_service.dart';
import '../../habits/data/models/habit.dart';
import 'widgets/today_habits_section.dart';

// ──────────── Helpers ────────────

Color _parseColor(String hex) {
  try {
    return Color(int.parse(hex, radix: 16));
  } catch (_) {
    return AppColors.primary;
  }
}

List<DateTime> _lastNDays(int count, DateTime anchor) {
  return List.generate(
    count,
    (i) => DateTime(anchor.year, anchor.month, anchor.day - (count - 1 - i)),
  );
}

// ──────────── Home Screen ────────────

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final days = _lastNDays(5, now);
    final habitsAsync = ref.watch(habitsProvider);
    final streakAsync = ref.watch(overallStreakProvider);
    final todayProgress = ref.watch(todayProgressProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ─── Header: Settings gear + App name + Stats + Add ───
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingLg,
                vertical: AppTheme.spacingSm,
              ),
              child: Row(
                children: [
                  // Settings gear
                  GestureDetector(
                    onTap: () => context.push('/settings'),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest
                            .withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.settings_outlined,
                        size: 20,
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // App Name
                  Text(
                    'Habit',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    'Flow',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      fontSize: 18,
                    ),
                  ),

                  const Spacer(),

                  // Streak icon
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('🔥', style: TextStyle(fontSize: 14)),
                        const SizedBox(width: 4),
                        Text(
                          streakAsync.when(
                            data: (s) => '$s',
                            loading: () => '-',
                            error: (_, __) => '0',
                          ),
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.accent,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Today percentage
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.pie_chart_rounded,
                            size: 14, color: AppColors.success),
                        const SizedBox(width: 4),
                        Text(
                          '${todayProgress.round()}%',
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.success,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Add habit button
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => const AddHabitSheet(),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.add_rounded,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 200.ms),

            const SizedBox(height: 12),

            // ─── "Last 5 days" label + Day headers ───
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppTheme.spacingLg),
              child: _DayHeaders(days: days),
            ),

            const SizedBox(height: 8),

            // ─── Habit Rows ───
            Expanded(
              child: habitsAsync.when(
                data: (habits) {
                  if (habits.isEmpty) return const _EmptyState();
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingLg),
                    itemCount: habits.length + 1, // +1 for ad
                    itemBuilder: (context, index) {
                      if (index == habits.length) {
                        return const Padding(
                          padding: EdgeInsets.only(top: 16, bottom: 80),
                          child: BannerAdWidget(),
                        );
                      }
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: _HabitRow(habit: habits[index], days: days),
                      )
                          .animate()
                          .fadeIn(delay: (50 * index).ms)
                          .slideX(begin: 0.1, duration: 200.ms);
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => Center(child: Text('$err')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────── Empty State ────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest
                  .withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: const Text('📝', style: TextStyle(fontSize: 48)),
          ),
          const SizedBox(height: 24),
          Text(
            'No habits yet',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Let's start tracking your goals!",
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => const AddHabitSheet(),
              );
            },
            icon: const Icon(Icons.add_rounded),
            label: const Text('Create your first habit'),
          ),
        ],
      ),
    );
  }
}

// ──────────── Day Headers (Last 5 days label + Mo 9, Tu 10...) ────────────

class _DayHeaders extends StatelessWidget {
  final List<DateTime> days;
  const _DayHeaders({required this.days});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final todayNorm = DateTime(now.year, now.month, now.day);

    return Row(
      children: [
        // "Last 5 days" chip
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest
                .withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
            ),
          ),
          child: Text(
            'Last 5 days',
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ),
        const Spacer(),
        // Day columns
        ...days.map((day) {
          final isToday = day == todayNorm;
          return SizedBox(
            width: 36,
            child: Column(
              children: [
                Text(
                  DateFormat('E').format(day).substring(0, 2),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurface
                        .withValues(alpha: isToday ? 0.9 : 0.4),
                    fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${day.day}',
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: isToday ? FontWeight.bold : FontWeight.w600,
                    color: theme.colorScheme.onSurface
                        .withValues(alpha: isToday ? 1.0 : 0.5),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

// ──────────── Habit Row (emoji + name + 5 tappable squares) ────────────

class _HabitRow extends ConsumerWidget {
  final Habit habit;
  final List<DateTime> days;

  const _HabitRow({required this.habit, required this.days});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final color = _parseColor(habit.colorHex);

    // We get month completions for the month of the LAST day in our range
    // This is a simplification; ideally we'd query range or fetch needed months.
    // Since range is 5 days, it's almost always one month, rarely spans two.
    final month = DateTime(days.last.year, days.last.month);

    final completedDaysAsync = ref.watch(
      habitMonthCompletionsProvider((habitId: habit.id!, month: month)),
    );

    return GestureDetector(
      onTap: () => context.go('/habits/${habit.id!}'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Emoji Container
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(habit.emoji, style: const TextStyle(fontSize: 20)),
              ),
            ),
            const SizedBox(width: 12),

            // Name (takes remaining space before squares)
            Expanded(
              child: Text(
                habit.name,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // 5 day squares
            ...days.map((day) {
              return completedDaysAsync.when(
                data: (completed) {
                  final done = completed.contains(day.day);
                  final now = DateTime.now();
                  final isToday = day.year == now.year &&
                      day.month == now.month &&
                      day.day == now.day;

                  return GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      ref
                          .read(habitNotifierProvider.notifier)
                          .toggleHabitForDate(habit.id!, day);
                    },
                    child: Container(
                      width: 28, // Slightly smaller squares for cleaner look
                      height: 28,
                      margin: const EdgeInsets.only(left: 8),
                      decoration: BoxDecoration(
                        color: done
                            ? color
                            : (isDark
                                ? color.withValues(alpha: 0.1)
                                : color.withValues(alpha: 0.05)),
                        borderRadius: BorderRadius.circular(8),
                        border: isToday && !done
                            ? Border.all(color: color, width: 2)
                            : null,
                      ),
                      child: done
                          ? Icon(Icons.check_rounded,
                              size: 16,
                              color: Colors.white.withValues(alpha: 0.9))
                          : null,
                    ),
                  );
                },
                loading: () => Container(
                  width: 28,
                  height: 28,
                  margin: const EdgeInsets.only(left: 8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                error: (_, __) => const SizedBox(width: 36),
              );
            }),
          ],
        ),
      ),
    );
  }
}
