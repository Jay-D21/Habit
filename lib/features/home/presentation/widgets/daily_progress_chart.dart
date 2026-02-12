import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../main.dart'; // database

/// Stream for watching habit completions changes
final completionsWatcherProvider =
    StreamProvider((ref) => database.select(database.habitCompletions).watch());

/// Provider for daily completions data
final dailyProgressProvider = FutureProvider<List<DayProgress>>((ref) async {
  // Watch for changes to refresh automatically
  ref.watch(completionsWatcherProvider);

  final now = DateTime.now();
  final List<DayProgress> data = [];

  // Get last 14 days of data
  for (int i = 13; i >= 0; i--) {
    final date = DateTime(now.year, now.month, now.day - i);

    // Count completions for this date
    final count = await (database.select(database.habitCompletions)
          ..where((c) => c.date.equals(date)))
        .get()
        .then((list) => list.length);

    data.add(DayProgress(date: date, count: count));
  }

  return data;
});

class DayProgress {
  final DateTime date;
  final int count;

  DayProgress({required this.date, required this.count});
}

/// Daily Progress Chart Widget for Home Screen
class DailyProgressChart extends ConsumerWidget {
  const DailyProgressChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final progressAsync = ref.watch(dailyProgressProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLg),
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacingLg),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.show_chart_rounded,
                    color: AppColors.primary, size: 20),
                const SizedBox(width: AppTheme.spacingSm),
                Text(
                  'Daily Progress',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Text(
              'Habits completed over the last 2 weeks',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: AppTheme.spacingMd),
            SizedBox(
              height: 120,
              child: progressAsync.when(
                data: (data) => _buildChart(context, data),
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (e, _) => Center(
                  child: Text('Error: $e'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChart(BuildContext context, List<DayProgress> data) {
    final theme = Theme.of(context);

    // Check if there's any data
    final hasData = data.any((d) => d.count > 0);

    if (!hasData) {
      return Center(
        child: Text(
          'Complete habits to see your progress!',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
          ),
        ),
      );
    }

    final maxY = data.map((d) => d.count).reduce((a, b) => a > b ? a : b);
    final chartMaxY = (maxY + 1).toDouble().clamp(3.0, 15.0);

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
          horizontalInterval: chartMaxY / 3,
          getDrawingHorizontalLine: (value) => FlLine(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.08),
            strokeWidth: 1,
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 22,
              interval: 3,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index >= 0 && index < data.length && index % 3 == 0) {
                  final date = data[index].date;
                  return Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      '${date.day}/${date.month}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.4),
                        fontSize: 9,
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          leftTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
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
            barWidth: 2.5,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 3,
                  color: AppColors.primary,
                  strokeWidth: 1.5,
                  strokeColor: Colors.white,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.primary.withValues(alpha: 0.2),
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
                final index = spot.x.toInt();
                final date = data[index].date;
                return LineTooltipItem(
                  '${date.day}/${date.month}: ${spot.y.toInt()} habits',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }
}
