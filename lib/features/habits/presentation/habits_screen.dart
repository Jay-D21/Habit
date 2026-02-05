import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_theme.dart';
import '../../../../core/providers/habit_providers.dart';
import '../data/models/habit.dart';
import '../../home/presentation/widgets/today_habits_section.dart';
import '../../../core/services/ad_service.dart';

/// Habits screen with calendar view
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
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
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
                  IconButton(
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
                      child: const Icon(
                        Icons.add_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 300.ms),

            // Month selector
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppTheme.spacingLg),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: _previousMonth,
                    icon: const Icon(Icons.chevron_left_rounded),
                  ),
                  Text(
                    DateFormat('MMMM yyyy').format(_selectedMonth),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    onPressed: _nextMonth,
                    icon: const Icon(Icons.chevron_right_rounded),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 300.ms, delay: 100.ms),

            // Calendar grid header
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingLg,
                vertical: AppTheme.spacingMd,
              ),
              child: Row(
                children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                    .map((day) => Expanded(
                          child: Center(
                            child: Text(
                              day,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.5),
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),

            // Habits list with calendar
            Expanded(
              child: _HabitsList(selectedMonth: _selectedMonth),
            ),

            // Banner Ad
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

class _HabitsList extends ConsumerWidget {
  final DateTime selectedMonth;

  const _HabitsList({required this.selectedMonth});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final habitsAsync = ref.watch(habitsProvider);

    return habitsAsync.when(
      data: (habits) {
        if (habits.isEmpty) {
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

        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLg),
          itemCount: habits.length + 1, // +1 for bottom padding
          separatorBuilder: (_, __) =>
              const SizedBox(height: AppTheme.spacingMd),
          itemBuilder: (context, index) {
            if (index == habits.length) return const SizedBox(height: 100);
            return _HabitCalendarCard(
              habit: habits[index],
              month: selectedMonth,
            ).animate().fadeIn(delay: (100 * index).ms);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}

class _HabitCalendarCard extends ConsumerWidget {
  final Habit habit;
  final DateTime month;

  const _HabitCalendarCard({
    required this.habit,
    required this.month,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final firstDayOfMonth = DateTime(month.year, month.month, 1);
    final lastDayOfMonth = DateTime(month.year, month.month + 1, 0);
    final daysInMonth = lastDayOfMonth.day;
    final startWeekday = firstDayOfMonth.weekday; // 1 = Monday

    // Watch completions for this habit in this month
    final completedDaysAsync = ref.watch(
        habitMonthCompletionsProvider((habitId: habit.id!, month: month)));

    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: completedDaysAsync.when(
        data: (completedDays) {
          // Calculate completion percentage
          final completedCount =
              completedDays.where((d) => d <= daysInMonth).length;
          final completionPercent =
              (completedCount / daysInMonth * 100).round();

          // Parse habit color
          Color habitColor;
          try {
            habitColor = Color(int.parse(habit.colorHex, radix: 16));
          } catch (_) {
            habitColor = AppColors.primary;
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Habit header
              Row(
                children: [
                  Text(habit.emoji, style: const TextStyle(fontSize: 24)),
                  const SizedBox(width: AppTheme.spacingSm),
                  Expanded(
                    child: Text(
                      habit.name,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingSm,
                      vertical: AppTheme.spacingXs,
                    ),
                    decoration: BoxDecoration(
                      color: habitColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                    ),
                    child: Text(
                      '$completionPercent%',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: habitColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spacingMd),

              // Mini calendar grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                ),
                itemCount: daysInMonth + startWeekday - 1,
                itemBuilder: (context, index) {
                  if (index < startWeekday - 1) {
                    return const SizedBox.shrink();
                  }

                  final day = index - startWeekday + 2;
                  final isCompleted = completedDays.contains(day);
                  final isToday = _isToday(day, month);

                  return Container(
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? habitColor // Use habit specific color
                          : (isDark
                              ? AppColors.surfaceDark
                              : AppColors.backgroundLight),
                      borderRadius: BorderRadius.circular(4),
                      border: isToday
                          ? Border.all(color: habitColor, width: 2)
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        '$day',
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontSize: 10,
                          color: isCompleted
                              ? Colors.white
                              : theme.colorScheme.onSurface
                                  .withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
        loading: () => const Center(
            child: Padding(
          padding: EdgeInsets.all(32.0),
          child: CircularProgressIndicator(),
        )),
        error: (_, __) => const Text('Error loading data'),
      ),
    );
  }

  bool _isToday(int day, DateTime month) {
    final now = DateTime.now();
    return now.year == month.year && now.month == month.month && now.day == day;
  }
}
