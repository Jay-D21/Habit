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
import '../../achievements/data/models/achievement.dart';
import '../../achievements/presentation/widgets/badge_item.dart';

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
              ..where((c) => c.date.isBiggerOrEqual(Variable(month)))
              ..where((c) => c.date.isSmallerOrEqual(Variable(actualEnd))))
            .get())
        .length;
    final days = actualEnd.day;
    final rate = habits > 0 && days > 0
        ? (completions / (habits * days) * 100).clamp(0, 100)
        : 0.0;
    data.add(
        MonthData(month: DateFormat('MMM').format(month), rate: rate.round()));
  }
  return data;
});

class AnalyticsStats {
  final int activeHabits;
  final int avgCompletion;
  final int longestStreak;
  final String bestMonth;
  AnalyticsStats(
      {required this.activeHabits,
      required this.avgCompletion,
      required this.longestStreak,
      required this.bestMonth});
}

class MonthData {
  final String month;
  final int rate;
  MonthData({required this.month, required this.rate});
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      child: Column(
        children: [
          _buildStatsCards(context, ref).animate().fadeIn(delay: 50.ms),
          const SizedBox(height: 24),
          _buildMonthlyProgress(context, ref, isDark)
              .animate()
              .fadeIn(delay: 100.ms),
          const SizedBox(height: 24),
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

  Widget _buildMonthlyProgress(
      BuildContext context, WidgetRef ref, bool isDark) {
    final theme = Theme.of(context);
    final monthlyAsync = ref.watch(monthlyProgressProvider);

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
          Text('Monthly Trend',
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          SizedBox(
            height: 150,
            child: monthlyAsync.when(
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
                            data[val.toInt()].month,
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
          return const Center(child: Text('No badges yet.'));
        }
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.7,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
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
            return BadgeItem(achievement: model)
                .animate()
                .scale(delay: (50 * index).ms);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: Text('Error loading badges')),
    );
  }
}
