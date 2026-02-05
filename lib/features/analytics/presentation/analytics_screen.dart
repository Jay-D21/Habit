import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:drift/drift.dart' as drift;
import 'package:intl/intl.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_theme.dart';
import '../../../main.dart'; // database global
import '../../../core/providers/habit_providers.dart';
import '../../../core/services/ad_service.dart';

/// Watch for database changes to trigger updates
final habitsTouchProvider =
    StreamProvider((ref) => database.select(database.habits).watch());
final completionsTouchProvider =
    StreamProvider((ref) => database.select(database.habitCompletions).watch());

/// Analytics stats provider
final analyticsStatsProvider = FutureProvider<AnalyticsStats>((ref) async {
  ref.watch(habitsTouchProvider);
  ref.watch(completionsTouchProvider);
  final now = DateTime.now();
  final startOfMonth = DateTime(now.year, now.month, 1);

  final activeHabits = (await database.getAllHabits()).length;

  final completionsThisMonth =
      (await (database.select(database.habitCompletions)
                ..where((c) => c.date.isBiggerOrEqualValue(startOfMonth))
                ..where((c) => c.date.isSmallerOrEqualValue(now)))
              .get())
          .length;

  // Calculate average completion rate
  final daysPassed = now.day;
  final avgRate = activeHabits > 0 && daysPassed > 0
      ? (completionsThisMonth / (activeHabits * daysPassed) * 100).clamp(0, 100)
      : 0.0;

  // Get longest streak
  final streakAsync = await ref.read(overallStreakProvider.future);

  return AnalyticsStats(
    activeHabits: activeHabits,
    avgCompletion: avgRate.round(),
    longestStreak: streakAsync,
    bestMonth: DateFormat('MMM yyyy').format(now),
  );
});

/// Monthly progress data provider
final monthlyProgressProvider = FutureProvider<List<MonthData>>((ref) async {
  ref.watch(habitsTouchProvider);
  ref.watch(completionsTouchProvider);
  final now = DateTime.now();
  final List<MonthData> data = [];

  for (int i = 2; i >= 0; i--) {
    final month = DateTime(now.year, now.month - i, 1);
    final endOfMonth = DateTime(month.year, month.month + 1, 0);
    final actualEnd = month.month == now.month ? now : endOfMonth;

    final habits = (await database.getAllHabits()).length;

    final completions = (await (database.select(database.habitCompletions)
              ..where((c) => c.date.isBiggerOrEqualValue(month))
              ..where((c) => c.date.isSmallerOrEqualValue(actualEnd)))
            .get())
        .length;

    final days = actualEnd.day;
    final rate = habits > 0 && days > 0
        ? (completions / (habits * days) * 100).clamp(0, 100)
        : 0.0;

    data.add(MonthData(
      month: DateFormat('MMM').format(month),
      rate: rate.round(),
    ));
  }

  return data;
});

/// Top habits provider
final topHabitsProvider = FutureProvider<List<TopHabit>>((ref) async {
  ref.watch(habitsTouchProvider);
  ref.watch(completionsTouchProvider);

  final activeHabitsList = await database.getAllHabits();

  if (activeHabitsList.isEmpty) return [];

  final now = DateTime.now();
  final startOfMonth = DateTime(now.year, now.month, 1);
  final daysPassed = now.day;

  // OPTIMIZED: Fetch ALL completions for this month in ONE query
  final allCompletions = await (database.select(database.habitCompletions)
        ..where((c) => c.date.isBiggerOrEqualValue(startOfMonth))
        ..where((c) => c.date.isSmallerOrEqualValue(now)))
      .get();

  // Group completions by habitId in memory
  final completionsByHabit = <int, int>{};
  for (final completion in allCompletions) {
    completionsByHabit[completion.habitId] =
        (completionsByHabit[completion.habitId] ?? 0) + 1;
  }

  final List<TopHabit> topHabits = [];
  final repo = ref.read(habitRepositoryProvider);

  // Now calculate stats for each habit using in-memory grouped data
  for (final habit in activeHabitsList) {
    final completions = completionsByHabit[habit.id] ?? 0;

    final rate =
        daysPassed > 0 ? (completions / daysPassed * 100).clamp(0, 100) : 0.0;

    final streak = await repo.calculateStreak(habit.id);

    topHabits.add(TopHabit(
      name: habit.name,
      emoji: habit.emoji,
      rate: rate.round(),
      streak: streak,
    ));
  }

  topHabits.sort((a, b) => b.rate.compareTo(a.rate));
  return topHabits.take(5).toList();
});

/// Daily activity provider (last 30 days)
final dailyActivityProvider = FutureProvider<List<DayActivity>>((ref) async {
  ref.watch(completionsTouchProvider);
  final now = DateTime.now();
  final List<DayActivity> data = [];

  for (int i = 29; i >= 0; i--) {
    final date = DateTime(now.year, now.month, now.day - i);
    // Normalize date to start of day for comparison
    final startOfDay = DateTime(date.year, date.month, date.day);

    final count = (await (database.select(database.habitCompletions)
              ..where((c) => c.date.equals(startOfDay)))
            .get())
        .length;

    data.add(DayActivity(date: date, count: count));
  }

  return data;
});

class AnalyticsStats {
  final int activeHabits;
  final int avgCompletion;
  final int longestStreak;
  final String bestMonth;

  AnalyticsStats({
    required this.activeHabits,
    required this.avgCompletion,
    required this.longestStreak,
    required this.bestMonth,
  });
}

class MonthData {
  final String month;
  final int rate;

  MonthData({required this.month, required this.rate});
}

class TopHabit {
  final String name;
  final String emoji;
  final int rate;
  final int streak;

  TopHabit({
    required this.name,
    required this.emoji,
    required this.rate,
    required this.streak,
  });
}

class DayActivity {
  final DateTime date;
  final int count;

  DayActivity({required this.date, required this.count});
}

/// Analytics screen matching website design
class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(AppTheme.spacingLg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Analytics',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Track your progress and identify patterns',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 300.ms),

              // Stats Cards Row
              _buildStatsCards(context, ref).animate().fadeIn(delay: 100.ms),

              const SizedBox(height: AppTheme.spacingLg),

              // Monthly Progress - Full Width
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppTheme.spacingLg),
                child: _buildMonthlyProgress(context, ref, isDark),
              ).animate().fadeIn(delay: 200.ms),

              const SizedBox(height: AppTheme.spacingLg),

              // Top Performing Habits - Full Width
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppTheme.spacingLg),
                child: _buildTopHabits(context, ref, isDark),
              ).animate().fadeIn(delay: 250.ms),

              const SizedBox(height: AppTheme.spacingLg),

              // Daily Activity (Line Graph)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppTheme.spacingLg),
                child: _buildDailyActivity(context, ref, isDark),
              ).animate().fadeIn(delay: 300.ms),

              const SizedBox(height: AppTheme.spacingLg),

              // Banner Ad
              const Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: AppTheme.spacingLg),
                child: BannerAdWidget(),
              ).animate().fadeIn(delay: 350.ms),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCards(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(analyticsStatsProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return statsAsync.when(
      data: (stats) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLg),
        child: Row(
          children: [
            _StatCard(
              icon: Icons.check_circle_outline_rounded,
              label: 'Active Habits',
              value: '${stats.activeHabits}',
              color: AppColors.primary,
              isDark: isDark,
            ),
            const SizedBox(width: AppTheme.spacingSm),
            _StatCard(
              icon: Icons.trending_up_rounded,
              label: 'Avg. Completion',
              value: '${stats.avgCompletion}%',
              color: AppColors.success,
              isDark: isDark,
            ),
            const SizedBox(width: AppTheme.spacingSm),
            _StatCard(
              icon: Icons.local_fire_department_rounded,
              label: 'Longest Streak',
              value: '${stats.longestStreak} days',
              color: AppColors.accent,
              isDark: isDark,
            ),
            const SizedBox(width: AppTheme.spacingSm),
            _StatCard(
              icon: Icons.calendar_month_rounded,
              label: 'Best Month',
              value: stats.bestMonth,
              color: AppColors.tertiary,
              isDark: isDark,
            ),
          ],
        ),
      ),
      loading: () => const SizedBox(height: 80),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildMonthlyProgress(
      BuildContext context, WidgetRef ref, bool isDark) {
    final theme = Theme.of(context);
    final monthlyAsync = ref.watch(monthlyProgressProvider);

    return Container(
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
            'Monthly Progress Trend',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Completion rates over time',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: AppTheme.spacingLg),
          SizedBox(
            height: 180,
            child: monthlyAsync.when(
              data: (data) => _buildBarChart(context, data),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => const Center(child: Text('Error loading data')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarChart(BuildContext context, List<MonthData> data) {
    final theme = Theme.of(context);

    if (data.isEmpty || data.every((d) => d.rate == 0)) {
      return Center(
        child: Text(
          'No data yet',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
          ),
        ),
      );
    }

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 100,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: AppColors.primary,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                '${rod.toY.round()}%',
                const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() < data.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      data[value.toInt()].month,
                      style: theme.textTheme.labelSmall,
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 35,
              interval: 25,
              getTitlesWidget: (value, meta) {
                return Text(
                  '${value.toInt()}%',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                );
              },
            ),
          ),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 25,
          getDrawingHorizontalLine: (value) => FlLine(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.08),
            strokeWidth: 1,
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: data.asMap().entries.map((entry) {
          return BarChartGroupData(
            x: entry.key,
            barRods: [
              BarChartRodData(
                toY: entry.value.rate.toDouble(),
                color: AppColors.primary,
                width: 40,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(6)),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTopHabits(BuildContext context, WidgetRef ref, bool isDark) {
    final theme = Theme.of(context);
    final topHabitsAsync = ref.watch(topHabitsProvider);

    return Container(
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
            'Top Performing Habits',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "This month's best habits",
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: AppTheme.spacingMd),
          topHabitsAsync.when(
            data: (habits) {
              if (habits.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(AppTheme.spacingLg),
                  child: Center(
                    child: Text(
                      'No habits yet',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.4),
                      ),
                    ),
                  ),
                );
              }
              return Column(
                children: habits.asMap().entries.map((entry) {
                  final index = entry.key;
                  final habit = entry.value;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(habit.emoji, style: const TextStyle(fontSize: 16)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                habit.name,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                '${habit.streak} day streak',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withValues(alpha: 0.4),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '${habit.rate}%',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.success,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => const Text('Error'),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyActivity(BuildContext context, WidgetRef ref, bool isDark) {
    final theme = Theme.of(context);
    final activityAsync = ref.watch(dailyActivityProvider);

    return Container(
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
            'Daily Activity (Last 30 Days)',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Number of habits completed each day',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: AppTheme.spacingLg),
          SizedBox(
            height: 150,
            child: activityAsync.when(
              data: (data) => _buildActivityLineChart(context, data),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => const Center(child: Text('Error')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityLineChart(BuildContext context, List<DayActivity> data) {
    final theme = Theme.of(context);

    final hasData = data.any((d) => d.count > 0);
    if (!hasData) {
      return Center(
        child: Text(
          'Complete habits to see activity!',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
          ),
        ),
      );
    }

    final maxY = data.map((d) => d.count).reduce((a, b) => a > b ? a : b);
    final chartMaxY = (maxY + 2).toDouble().clamp(4.0, 20.0);

    final spots = data
        .asMap()
        .entries
        .map((entry) => FlSpot(
              entry.key.toDouble(),
              entry.value.count.toDouble(),
            ))
        .toList();

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: chartMaxY / 4,
          getDrawingHorizontalLine: (value) => FlLine(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.08),
            strokeWidth: 1,
          ),
        ),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: (data.length - 1).toDouble(),
        minY: 0,
        maxY: chartMaxY,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            curveSmoothness: 0.35,
            color: AppColors.primary,
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 2,
                  color: AppColors.primary,
                  strokeWidth: 0,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.primary.withValues(alpha: 0.15),
                  AppColors.primary.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: AppColors.primary,
            getTooltipItems: (spots) {
              return spots.map((spot) {
                return LineTooltipItem(
                  '${spot.y.toInt()} habits',
                  const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final bool isDark;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacingMd),
        decoration: BoxDecoration(
          color: color.withValues(alpha: isDark ? 0.15 : 0.08),
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          border: Border.all(
            color: color.withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: color),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    label,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
