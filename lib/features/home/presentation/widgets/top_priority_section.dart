import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../core/providers/habit_providers.dart';
import '../../../habits/presentation/widgets/habit_card.dart';

/// Section showing only High (4) and Critical (5) priority habits
class TopPrioritySection extends ConsumerWidget {
  const TopPrioritySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final habitsAsync = ref.watch(habitsProvider);

    return habitsAsync.when(
      data: (habits) {
        // Filter for Priority >= 4 AND Not Completed
        final topPriorityHabits = habits.where((h) {
          final isCompleted = ref.watch(isHabitCompletedTodayProvider(h.id!));
          return h.priority >= 4 && !isCompleted;
        }).toList();

        // Sort by priority (descending)
        topPriorityHabits.sort((a, b) => b.priority.compareTo(a.priority));

        if (topPriorityHabits.isEmpty) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.stars_rounded, color: Colors.orange, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Top Priority Today',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              )
                  .animate()
                  .fadeIn()
                  .slideX(begin: -0.1, end: 0, duration: 300.ms),
              const SizedBox(height: AppTheme.spacingMd),

              // Only show top 2 to avoid clutter, or all if small number
              ...topPriorityHabits.take(3).map((habit) => Padding(
                    padding: const EdgeInsets.only(bottom: AppTheme.spacingSm),
                    child: HabitCard(habit: habit)
                        .animate()
                        .fadeIn()
                        .slideY(begin: 0.1, end: 0, duration: 400.ms),
                  )),

              const SizedBox(height: AppTheme.spacingMd),
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
