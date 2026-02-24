import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/providers/habit_providers.dart';
import '../../../core/providers/habit_notifier.dart';
import '../../../core/providers/gamification_providers.dart';
import '../../../core/services/ad_service.dart';
import '../../habits/data/models/habit.dart';
import '../../habits/presentation/widgets/add_habit_sheet.dart';
// Let's check HomeScreen usage. Line 404: todayProgressProvider is used, but TodayHabitsSection?
// Line 332: return const _EmptyState();
// Wait, is TodayHabitsSection used in home_screen.dart?
// Let's check the view_file output again.

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

// ──────────── Motivational Quotes ────────────

const _quotes = [
  '"The secret of getting ahead is getting started." — Mark Twain',
  '"Small daily improvements lead to staggering long-term results."',
  '"We are what we repeatedly do. Excellence is a habit." — Aristotle',
  '"Success is the sum of small efforts, repeated." — Robert Collier',
  '"A journey of a thousand miles begins with a single step." — Lao Tzu',
  '"Don\'t watch the clock; do what it does. Keep going." — Sam Levenson',
  '"Motivation is what gets you started. Habit keeps you going." — Jim Ryun',
  '"It does not matter how slowly you go as long as you do not stop." — Confucius',
  '"Believe you can and you\'re halfway there." — Theodore Roosevelt',
  '"You don\'t have to be great to start, but you have to start to be great."',
];

String _todayQuote() {
  final dayOfYear =
      DateTime.now().difference(DateTime(DateTime.now().year)).inDays;
  return _quotes[dayOfYear % _quotes.length];
}

// ──────────── Home Screen ────────────

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final now = DateTime.now();
    final days = _lastNDays(5, now);
    final habitsAsync = ref.watch(habitsProvider);
    final streakAsync = ref.watch(overallStreakProvider);
    final todayProgress = ref.watch(todayProgressProvider);
    final xpAsync = ref.watch(userProgressProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ─── Header Row ───
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingLg,
                vertical: AppTheme.spacingSm,
              ),
              child: Row(
                children: [
                  // XP badge
                  xpAsync.when(
                    data: (progress) {
                      final xp = progress?.xp ?? 0;
                      final level = progress?.level ?? 1;
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF6C5CE7), Color(0xFFA29BFE)],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF6C5CE7)
                                  .withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('⚡', style: TextStyle(fontSize: 14)),
                            const SizedBox(width: 6),
                            Text(
                              'Lv$level · ${xp}XP',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                  ),
                  const SizedBox(width: 16),

                  // App name
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

                  // Streak
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

                  // Add habit
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

            // ─── Motivational Quote ───
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingLg, vertical: 8),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [
                            AppColors.primary.withValues(alpha: 0.12),
                            AppColors.primary.withValues(alpha: 0.06),
                          ]
                        : [
                            AppColors.primary.withValues(alpha: 0.08),
                            AppColors.primary.withValues(alpha: 0.03),
                          ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.05),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.format_quote_rounded,
                      size: 24,
                      color: AppColors.primary.withValues(alpha: 0.4),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _todayQuote(),
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontStyle: FontStyle.italic,
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.85),
                        height: 1.6,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ).animate().fadeIn(delay: 100.ms).scale(delay: 100.ms),

            const SizedBox(height: 12),

            // ─── Day headers ───
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppTheme.spacingLg),
              child: _DayHeaders(days: days),
            ),

            const SizedBox(height: 8),

            // ─── Habit Rows + Weekly Chart + Ad ───
            Expanded(
              child: habitsAsync.when(
                data: (habits) {
                  if (habits.isEmpty) return const _EmptyState();
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingLg),
                    itemCount: habits.length + 2, // +1 chart, +1 ad
                    itemBuilder: (context, index) {
                      // Habit rows
                      if (index < habits.length) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: _HabitRow(habit: habits[index], days: days),
                        )
                            .animate()
                            .fadeIn(delay: (50 * index).ms)
                            .slideX(begin: 0.1, duration: 200.ms);
                      }
                      // Weekly chart
                      if (index == habits.length) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 16, bottom: 12),
                          child: _WeeklyChart(isDark: isDark),
                        ).animate().fadeIn(delay: 200.ms);
                      }
                      // Ad
                      return const Padding(
                        padding: EdgeInsets.only(bottom: 80),
                        child: BannerAdWidget(),
                      );
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

// ──────────── Weekly Line Chart ────────────

class _WeeklyChart extends ConsumerWidget {
  final bool isDark;
  const _WeeklyChart({required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final weeklyAsync = ref.watch(weeklyProgressProvider);
    final now = DateTime.now();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Weekly Progress',
              style: theme.textTheme.titleSmall
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          SizedBox(
            height: 120,
            child: weeklyAsync.when(
              data: (data) => LineChart(
                LineChartData(
                  minY: 0,
                  maxY: 100,
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 50,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color:
                          theme.colorScheme.onSurface.withValues(alpha: 0.05),
                      strokeWidth: 1,
                    ),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        getTitlesWidget: (value, _) {
                          final day =
                              now.subtract(Duration(days: 6 - value.toInt()));
                          return Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              DateFormat('E').format(day).substring(0, 2),
                              style: theme.textTheme.labelSmall?.copyWith(
                                fontSize: 9,
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.4),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: data
                          .asMap()
                          .entries
                          .map((e) => FlSpot(e.key.toDouble(), e.value))
                          .toList(),
                      isCurved: true,
                      color: AppColors.primary,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, bar, index) =>
                            FlDotCirclePainter(
                          radius: 3,
                          color: AppColors.primary,
                          strokeWidth: 0,
                        ),
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        color: AppColors.primary.withValues(alpha: 0.1),
                      ),
                    ),
                  ],
                ),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => const SizedBox.shrink(),
            ),
          ),
        ],
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

// ──────────── Day Headers ────────────

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

// ──────────── Habit Row ────────────

class _HabitRow extends ConsumerWidget {
  final Habit habit;
  final List<DateTime> days;

  const _HabitRow({required this.habit, required this.days});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final color = _parseColor(habit.colorHex);

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
                      width: 28,
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
