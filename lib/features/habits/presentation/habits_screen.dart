import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_theme.dart';
import '../../../../core/providers/habit_providers.dart';
import '../../../../core/providers/habit_notifier.dart';
import '../../../shared/widgets/icon_emoji_picker.dart';
import '../data/models/habit.dart';
import 'widgets/add_habit_sheet.dart';
import '../../../core/services/ad_service.dart';

// ──────────── Helpers ────────────

/// Parse a hex color string to Color, fallback to primary
Color _parseHabitColor(String hex) {
  try {
    return Color(int.parse(hex, radix: 16));
  } catch (_) {
    return AppColors.primary;
  }
}

/// Generate the last N days ending at [anchor], returns newest-last order
List<DateTime> _lastNDays(int count, DateTime anchor) {
  return List.generate(
    count,
    (i) => DateTime(anchor.year, anchor.month, anchor.day - (count - 1 - i)),
  );
}

// ──────────── Main Screen ────────────

class HabitsScreen extends ConsumerStatefulWidget {
  const HabitsScreen({super.key});

  @override
  ConsumerState<HabitsScreen> createState() => _HabitsScreenState();
}

class _HabitsScreenState extends ConsumerState<HabitsScreen> {
  DateTime _selectedMonth = DateTime.now();

  void _previousMonth() {
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month - 1);
    });
  }

  void _nextMonth() {
    final now = DateTime.now();
    // Don't go past current month
    if (_selectedMonth.year >= now.year && _selectedMonth.month >= now.month) {
      return;
    }
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final days = _lastNDays(5, now);
    final habitsAsync = ref.watch(habitsProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Header ───
            Padding(
              padding: const EdgeInsets.all(AppTheme.spacingLg),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'My Habits',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _AddHabitButton(),
                ],
              ),
            ).animate().fadeIn(duration: 300.ms),

            // ─── Content ───
            Expanded(
              child: habitsAsync.when(
                data: (habits) {
                  if (habits.isEmpty) return const _EmptyState();
                  return _HabitsContent(
                    habits: habits,
                    days: days,
                    selectedMonth: _selectedMonth,
                    onPreviousMonth: _previousMonth,
                    onNextMonth: _nextMonth,
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => Center(child: Text('Error: $err')),
              ),
            ),

            // ─── Ad ───
            const Padding(
              padding: EdgeInsets.all(AppTheme.spacingLg),
              child: BannerAdWidget(),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────── Add Habit Button ────────────

class _AddHabitButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => const AddHabitSheet(),
        );
      },
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        ),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 24),
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
          const Text('📝', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 16),
          Text(
            'No habits yet',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => const AddHabitSheet(),
              );
            },
            child: const Text('Create your first habit'),
          ),
        ],
      ),
    );
  }
}

// ──────────── Main Content (day squares + month grid) ────────────

class _HabitsContent extends StatelessWidget {
  final List<Habit> habits;
  final List<DateTime> days;
  final DateTime selectedMonth;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;

  const _HabitsContent({
    required this.habits,
    required this.days,
    required this.selectedMonth,
    required this.onPreviousMonth,
    required this.onNextMonth,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Day Headers Row ───
          _DayHeadersRow(days: days),
          const SizedBox(height: AppTheme.spacingSm),

          // ─── Habit Rows with Day Squares ───
          ...habits.map((habit) => Padding(
                padding: const EdgeInsets.only(bottom: AppTheme.spacingSm),
                child: _HabitDayRow(habit: habit, days: days),
              )),

          const NativeAdWidget(),

          const SizedBox(height: AppTheme.spacingXl),

          // ─── Month Box Grid Section ───
          _MonthSelector(
            selectedMonth: selectedMonth,
            onPrevious: onPreviousMonth,
            onNext: onNextMonth,
          ),
          const SizedBox(height: AppTheme.spacingMd),

          // ─── Month Grids per Habit ───
          ...habits.map((habit) => Padding(
                padding: const EdgeInsets.only(bottom: AppTheme.spacingMd),
                child: _HabitMonthGrid(
                  habit: habit,
                  month: selectedMonth,
                ),
              )),

          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

// ──────────── Day Headers Row (Mo 9, Tu 10 ...) ────────────

class _DayHeadersRow extends StatelessWidget {
  final List<DateTime> days;
  const _DayHeadersRow({required this.days});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final todayNorm = DateTime(now.year, now.month, now.day);

    return Row(
      children: [
        // Left spacer (matches habit name width)
        const SizedBox(width: 120),
        // Day columns
        ...days.map((day) {
          final isToday = day == todayNorm;
          return Expanded(
            child: Column(
              children: [
                Text(
                  DateFormat('E').format(day).substring(0, 2),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurface
                        .withValues(alpha: isToday ? 0.9 : 0.4),
                    fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                Text(
                  '${day.day}',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: isToday ? FontWeight.bold : FontWeight.w500,
                    color: theme.colorScheme.onSurface
                        .withValues(alpha: isToday ? 1.0 : 0.6),
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

// ──────────── Habit Day Row (emoji + name + 5 tappable squares) ────────────

class _HabitDayRow extends ConsumerWidget {
  final Habit habit;
  final List<DateTime> days;

  const _HabitDayRow({required this.habit, required this.days});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final habitColor = _parseHabitColor(habit.colorHex);

    // Get this month's completions
    final month = DateTime(days.last.year, days.last.month);
    final completedDaysAsync = ref.watch(
      habitMonthCompletionsProvider((habitId: habit.id!, month: month)),
    );

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingSm,
        vertical: AppTheme.spacingMd,
      ),
      decoration: BoxDecoration(
        color: isDark
            ? habitColor.withValues(alpha: 0.06)
            : habitColor.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Row(
        children: [
          // Emoji + Name
          SizedBox(
            width: 110,
            child: Row(
              children: [
                buildIconEmojiDisplay(habit.emoji, size: 20),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    habit.name,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          // Day squares
          ...days.map((day) {
            return Expanded(
              child: completedDaysAsync.when(
                data: (completedDays) {
                  final isCompleted = completedDays.contains(day.day);
                  return _DaySquare(
                    habitId: habit.id!,
                    date: day,
                    color: habitColor,
                    isCompleted: isCompleted,
                    isDark: isDark,
                  );
                },
                loading: () => _DaySquarePlaceholder(
                  color: habitColor,
                  isDark: isDark,
                ),
                error: (_, __) => _DaySquarePlaceholder(
                  color: habitColor,
                  isDark: isDark,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ──────────── Single Tappable Day Square ────────────

class _DaySquare extends ConsumerWidget {
  final int habitId;
  final DateTime date;
  final Color color;
  final bool isCompleted;
  final bool isDark;

  const _DaySquare({
    required this.habitId,
    required this.date,
    required this.color,
    required this.isCompleted,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final isToday =
        date.year == now.year && date.month == now.month && date.day == now.day;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        ref.read(habitNotifierProvider.notifier).toggleHabitForDate(
              habitId,
              date,
            );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 3),
        height: 32,
        decoration: BoxDecoration(
          color: isCompleted
              ? color
              : (isDark
                  ? color.withValues(alpha: 0.1)
                  : color.withValues(alpha: 0.06)),
          borderRadius: BorderRadius.circular(6),
          border: isToday ? Border.all(color: color, width: 2) : null,
        ),
      ),
    );
  }
}

// ──────────── Day Square Placeholder (loading) ────────────

class _DaySquarePlaceholder extends StatelessWidget {
  final Color color;
  final bool isDark;
  const _DaySquarePlaceholder({required this.color, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 3),
      height: 32,
      decoration: BoxDecoration(
        color: isDark
            ? color.withValues(alpha: 0.05)
            : color.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}

// ──────────── Month Selector ────────────

class _MonthSelector extends StatelessWidget {
  final DateTime selectedMonth;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const _MonthSelector({
    required this.selectedMonth,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: onPrevious,
          icon: const Icon(Icons.chevron_left_rounded, size: 20),
        ),
        Text(
          DateFormat('MMMM yyyy').format(selectedMonth),
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        IconButton(
          onPressed: onNext,
          icon: const Icon(Icons.chevron_right_rounded, size: 20),
        ),
      ],
    );
  }
}

// ──────────── Habit Month Grid (compact box view) ────────────

class _HabitMonthGrid extends ConsumerWidget {
  final Habit habit;
  final DateTime month;

  const _HabitMonthGrid({required this.habit, required this.month});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final habitColor = _parseHabitColor(habit.colorHex);

    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final startWeekday = DateTime(month.year, month.month, 1).weekday;

    final completedDaysAsync = ref.watch(
      habitMonthCompletionsProvider((habitId: habit.id!, month: month)),
    );

    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Habit label
          Row(
            children: [
              buildIconEmojiDisplay(habit.emoji, size: 18),
              const SizedBox(width: 8),
              Text(
                habit.name,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingSm),

          // Box grid
          completedDaysAsync.when(
            data: (completedDays) => GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 3,
                crossAxisSpacing: 3,
              ),
              itemCount: daysInMonth + startWeekday - 1,
              itemBuilder: (context, index) {
                // Empty cells for alignment
                if (index < startWeekday - 1) {
                  return const SizedBox.shrink();
                }

                final day = index - startWeekday + 2;
                final isCompleted = completedDays.contains(day);
                final now = DateTime.now();
                final isToday = now.year == month.year &&
                    now.month == month.month &&
                    now.day == day;

                return GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    final date = DateTime(month.year, month.month, day);
                    ref
                        .read(habitNotifierProvider.notifier)
                        .toggleHabitForDate(habit.id!, date);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? habitColor
                          : (isDark
                              ? habitColor.withValues(alpha: 0.08)
                              : habitColor.withValues(alpha: 0.04)),
                      borderRadius: BorderRadius.circular(4),
                      border: isToday
                          ? Border.all(color: habitColor, width: 1.5)
                          : null,
                    ),
                  ),
                );
              },
            ),
            loading: () => const SizedBox(
              height: 60,
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            ),
            error: (_, __) => const Text('Error'),
          ),
        ],
      ),
    );
  }
}
