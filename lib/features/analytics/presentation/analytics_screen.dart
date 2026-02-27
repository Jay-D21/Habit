import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:intl/intl.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_theme.dart';
import '../../../main.dart'; // database global
import '../../../core/providers/habit_providers.dart';
import '../../../core/providers/gamification_providers.dart';
import '../../../core/services/ad_service.dart';
import '../../achievements/presentation/widgets/badge_item.dart';
import '../../achievements/data/models/achievement.dart';

// ──────────── Period Enum ────────────

enum StatsPeriod {
  week7('Last 7 days', 7),
  days30('Last 30 days', 30),
  days90('Last 90 days', 90);

  final String label;
  final int days;
  const StatsPeriod(this.label, this.days);
}

final selectedPeriodProvider =
    StateProvider<StatsPeriod>((ref) => StatsPeriod.week7);

// ──────────── Providers ────────────

final habitsTouchProvider =
    StreamProvider((ref) => database.select(database.habits).watch());
final completionsTouchProvider =
    StreamProvider((ref) => database.select(database.habitCompletions).watch());

final analyticsStatsProvider = FutureProvider<AnalyticsStats>((ref) async {
  ref.watch(habitsTouchProvider);
  ref.watch(completionsTouchProvider);
  final now = DateTime.now();
  final startOfMonth = DateTime(now.year, now.month, 1);
  final activeHabits = (await database.getAllHabits()).length;
  final completionsThisMonth =
      (await (database.select(database.habitCompletions)
                ..where((c) => c.date.isBiggerOrEqual(Variable(startOfMonth)))
                ..where((c) => c.date.isSmallerOrEqual(Variable(now))))
              .get())
          .length;
  final daysPassed = now.day;
  final avgRate = activeHabits > 0 && daysPassed > 0
      ? (completionsThisMonth / (activeHabits * daysPassed) * 100).clamp(0, 100)
      : 0.0;
  final streakAsync = await ref.read(overallStreakProvider.future);
  return AnalyticsStats(
    activeHabits: activeHabits,
    avgCompletion: avgRate.round(),
    longestStreak: streakAsync,
    bestMonth: DateFormat('MMM yyyy').format(now),
  );
});

// Daily completion data for line chart
final dailyCompletionProvider =
    FutureProvider.family<List<DayData>, int>((ref, days) async {
  ref.watch(habitsTouchProvider);
  ref.watch(completionsTouchProvider);
  final now = DateTime.now();
  final List<DayData> data = [];

  for (int i = days - 1; i >= 0; i--) {
    final day = DateTime(now.year, now.month, now.day - i);
    final habits = (await database.getAllHabits()).length;
    final completions = (await (database.select(database.habitCompletions)
              ..where((c) => c.date.equals(day)))
            .get())
        .length;
    final rate = habits > 0 ? (completions / habits * 100).clamp(0, 100) : 0.0;
    data.add(DayData(day: day, rate: rate.round()));
  }
  return data;
});

// Period-based bar chart data
final periodProgressProvider =
    FutureProvider.family<List<BarData>, int>((ref, days) async {
  ref.watch(habitsTouchProvider);
  ref.watch(completionsTouchProvider);
  final now = DateTime.now();

  // Group days into weeks or months depending on period
  final List<BarData> data = [];
  if (days <= 30) {
    // Group by weeks
    final weeks = (days / 7).ceil();
    for (int i = 0; i < weeks; i++) {
      final weekStart = DateTime(now.year, now.month, now.day - days + (i * 7));
      final weekEnd =
          DateTime(now.year, now.month, now.day - days + ((i + 1) * 7))
              .subtract(const Duration(days: 1));
      final actualEnd = weekEnd.isAfter(now) ? now : weekEnd;

      final habits = (await database.getAllHabits()).length;
      final completions = (await (database.select(database.habitCompletions)
                ..where((c) => c.date.isBiggerOrEqual(Variable(weekStart)))
                ..where((c) => c.date.isSmallerOrEqual(Variable(actualEnd))))
              .get())
          .length;
      final daysInRange = actualEnd.difference(weekStart).inDays + 1;
      final rate = habits > 0 && daysInRange > 0
          ? (completions / (habits * daysInRange) * 100).clamp(0, 100)
          : 0.0;
      data.add(BarData(label: 'W${i + 1}', rate: rate.round()));
    }
  } else {
    // Group by months
    final months = (days / 30).ceil();
    for (int i = months - 1; i >= 0; i--) {
      final month = DateTime(now.year, now.month - i, 1);
      final endOfMonth = DateTime(month.year, month.month + 1, 0);
      final actualEnd = month.month == now.month ? now : endOfMonth;
      final habits = (await database.getAllHabits()).length;
      final completions = (await (database.select(database.habitCompletions)
                ..where((c) => c.date.isBiggerOrEqual(Variable(month)))
                ..where((c) => c.date.isSmallerOrEqual(Variable(actualEnd))))
              .get())
          .length;
      final daysInMonth = actualEnd.day;
      final rate = habits > 0 && daysInMonth > 0
          ? (completions / (habits * daysInMonth) * 100).clamp(0, 100)
          : 0.0;
      data.add(
          BarData(label: DateFormat('MMM').format(month), rate: rate.round()));
    }
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

class DayData {
  final DateTime day;
  final int rate;
  DayData({required this.day, required this.rate});
}

class BarData {
  final String label;
  final int rate;
  BarData({required this.label, required this.rate});
}

// ──────────── Screen ────────────

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Stats',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: false,
          automaticallyImplyLeading: false,
          bottom: TabBar(
            splashFactory: NoSplash.splashFactory,
            overlayColor: WidgetStateProperty.all(Colors.transparent),
            dividerColor: Colors.transparent,
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor:
                theme.colorScheme.onSurface.withValues(alpha: 0.5),
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            tabs: const [
              Tab(text: 'Overview'),
              Tab(text: 'Badges'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _OverviewTab(),
            _BadgesTab(),
          ],
        ),
      ),
    );
  }
}

// ──────────── Overview Tab ────────────

class _OverviewTab extends ConsumerWidget {
  const _OverviewTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final selectedPeriod = ref.watch(selectedPeriodProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Period selector
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : AppColors.cardLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<StatsPeriod>(
                value: selectedPeriod,
                isDense: true,
                icon: const Icon(Icons.arrow_drop_down_rounded),
                borderRadius: BorderRadius.circular(12),
                items: StatsPeriod.values.map((period) {
                  return DropdownMenuItem(
                    value: period,
                    child: Text(
                      period.label,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (period) {
                  if (period != null) {
                    ref.read(selectedPeriodProvider.notifier).state = period;
                  }
                },
              ),
            ),
          ).animate().fadeIn(delay: 50.ms),

          const SizedBox(height: 24),

          _buildStatsCards(context, ref).animate().fadeIn(delay: 100.ms),
          const SizedBox(height: 24),

          _buildLineChart(context, ref, isDark, selectedPeriod)
              .animate()
              .fadeIn(delay: 150.ms),
          const SizedBox(height: 24),

          _buildBarChart(context, ref, isDark, selectedPeriod)
              .animate()
              .fadeIn(delay: 200.ms),
          const SizedBox(height: 24),

          const NativeAdWidget(),

          const BannerAdWidget(),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildStatsCards(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(analyticsStatsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return statsAsync.when(
      data: (stats) => Row(
        children: [
          _StatCard(
            label: 'Completion',
            value: '${stats.avgCompletion}%',
            icon: Icons.pie_chart_rounded,
            color: AppColors.success,
            isDark: isDark,
          ),
          const SizedBox(width: 12),
          _StatCard(
            label: 'Streak',
            value: '${stats.longestStreak} days',
            icon: Icons.local_fire_department_rounded,
            color: AppColors.accent,
            isDark: isDark,
          ),
          const SizedBox(width: 12),
          _StatCard(
            label: 'Total Habits',
            value: '${stats.activeHabits}',
            icon: Icons.checklist_rounded,
            color: AppColors.primary,
            isDark: isDark,
          ),
        ],
      ),
      loading: () => const SizedBox(height: 100),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildLineChart(
      BuildContext context, WidgetRef ref, bool isDark, StatsPeriod period) {
    final theme = Theme.of(context);
    final dailyAsync = ref.watch(dailyCompletionProvider(period.days));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Daily Completion Trend',
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          SizedBox(
            height: 150,
            child: dailyAsync.when(
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
                        interval: period.days <= 7
                            ? 1
                            : (period.days / 7).ceil().toDouble(),
                        getTitlesWidget: (value, _) {
                          if (value.toInt() >= data.length) {
                            return const SizedBox();
                          }
                          final day = data[value.toInt()].day;
                          return Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              period.days <= 7
                                  ? DateFormat('E').format(day).substring(0, 2)
                                  : '${day.day}',
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
                          .map((e) =>
                              FlSpot(e.key.toDouble(), e.value.rate.toDouble()))
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

  Widget _buildBarChart(
      BuildContext context, WidgetRef ref, bool isDark, StatsPeriod period) {
    final theme = Theme.of(context);
    final barAsync = ref.watch(periodProgressProvider(period.days));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Period Overview',
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          SizedBox(
            height: 150,
            child: barAsync.when(
              data: (data) => BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 100,
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (val, _) => Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            data[val.toInt()].label,
                            style: theme.textTheme.labelSmall,
                          ),
                        ),
                      ),
                    ),
                    leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  barGroups: data.asMap().entries.map((e) {
                    return BarChartGroupData(
                      x: e.key,
                      barRods: [
                        BarChartRodData(
                            toY: e.value.rate.toDouble(),
                            color: AppColors.primary,
                            width: 20,
                            borderRadius: BorderRadius.circular(4)),
                      ],
                    );
                  }).toList(),
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

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final bool isDark;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: isDark ? 0.15 : 0.08),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(value,
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold, color: color)),
            Text(label,
                style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    fontSize: 10)),
          ],
        ),
      ),
    );
  }
}

// ──────────── Badges Tab ────────────

class _BadgesTab extends ConsumerWidget {
  const _BadgesTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final achievementsAsync = ref.watch(achievementsProvider);

    return achievementsAsync.when(
      data: (achievements) {
        if (achievements.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('🏆', style: TextStyle(fontSize: 48)),
                const SizedBox(height: 16),
                Text(
                  'No badges yet',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.5),
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Complete habits to earn badges!',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.4),
                      ),
                ),
              ],
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(AppTheme.spacingLg),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: AppTheme.spacingMd,
            mainAxisSpacing: AppTheme.spacingMd,
            childAspectRatio: 0.85,
          ),
          itemCount: achievements.length,
          itemBuilder: (context, index) {
            final entity = achievements[index];
            final model = AchievementModel(
              id: entity.id,
              key: entity.key,
              name: entity.name,
              description: entity.description,
              icon: entity.icon,
              type: AchievementType.values[entity.type],
              targetValue: entity.targetValue,
              currentValue: entity.currentValue,
              xpReward: entity.xpReward,
              isUnlocked: entity.isUnlocked,
              unlockedAt: entity.unlockedAt,
            );
            return BadgeItem(achievement: model);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: Text('Error loading badges')),
    );
  }
}
