import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../core/providers/habit_providers.dart';
import '../../../habits/data/models/habit.dart';
import '../../../habits/presentation/widgets/habit_card.dart';
import '../../../habits/presentation/widgets/add_habit_sheet.dart';

/// Today's habits section with habit list
class TodayHabitsSection extends ConsumerWidget {
  const TodayHabitsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final habitsAsync = ref.watch(habitsProvider);
    final completionsAsync = ref.watch(todayCompletionsProvider);

    return Padding(
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Today's Habits",
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () => context.go('/habits'),
                child: const Text('See All'),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingMd),

          // Habits list
          habitsAsync.when(
            data: (habits) {
              return completionsAsync.when(
                data: (completions) {
                  // Sort habits:
                  // 1. Incomplete first
                  // 2. High priority first
                  // 3. Custom sort order
                  final sortedHabits = List<Habit>.from(habits);
                  sortedHabits.sort((a, b) {
                    final aComp = completions
                        .where((c) => c.habitId == a.id)
                        .fold(0, (sum, c) => sum + c.count);
                    final bComp = completions
                        .where((c) => c.habitId == b.id)
                        .fold(0, (sum, c) => sum + c.count);

                    final aIsDone = aComp >= a.targetCount;
                    final bIsDone = bComp >= b.targetCount;

                    if (aIsDone != bIsDone) {
                      return aIsDone ? 1 : -1; // Incomplete first
                    }

                    final priorityDiff = b.priority.compareTo(a.priority);
                    if (priorityDiff != 0) return priorityDiff;
                    return a.sortOrder.compareTo(b.sortOrder);
                  });

                  // If no habits exist
                  if (sortedHabits.isEmpty) {
                    return _EmptyHabitsState(
                      onAddHabit: () => _showAddHabitSheet(context, ref),
                    );
                  }

                  return Column(
                    children: sortedHabits
                        .map((habit) => Padding(
                              padding: const EdgeInsets.only(
                                  bottom: AppTheme.spacingSm),
                              child: HabitCard(habit: habit),
                            ))
                        .toList(),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Text('Error loading completions: $e'),
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (error, stack) => Center(
              child: Text('Error: $error'),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddHabitSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddHabitSheet(),
    );
  }
}

class _EmptyHabitsState extends StatelessWidget {
  final VoidCallback onAddHabit;

  const _EmptyHabitsState({required this.onAddHabit});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingXl),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        children: [
          const Text('🎯', style: TextStyle(fontSize: 48)),
          const SizedBox(height: AppTheme.spacingMd),
          Text(
            'No habits yet',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppTheme.spacingXs),
          Text(
            'Start building your first habit today!',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.spacingLg),
          ElevatedButton.icon(
            onPressed: onAddHabit,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Create First Habit'),
          ),
        ],
      ),
    );
  }
}
