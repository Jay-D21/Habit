import 'package:flutter/material.dart';
import '../../core/models/priority_enum.dart';

class PrioritySelectorWidget extends StatelessWidget {
  final HabitPriority selectedPriority;
  final ValueChanged<HabitPriority> onPriorityChanged;

  const PrioritySelectorWidget({
    super.key,
    required this.selectedPriority,
    required this.onPriorityChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Priority',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(5, (index) {
                  final priority = HabitPriority.values[index];
                  final isSelected = priority == selectedPriority;
                  final isBelowSelected =
                      priority.value <= selectedPriority.value;

                  return GestureDetector(
                    onTap: () => onPriorityChanged(priority),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? priority.color.withValues(alpha: 0.15)
                            : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isBelowSelected
                            ? Icons.star_rounded
                            : Icons.star_outline_rounded,
                        color: isBelowSelected
                            ? priority.color
                            : theme.colorScheme.outline.withValues(alpha: 0.5),
                        size: 32,
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 12),
              // Description and XP Info
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: selectedPriority.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      size: 14,
                      color: selectedPriority.color,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${selectedPriority.label} · ${selectedPriority.xpMultiplier}x XP Reward',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: selectedPriority.color
                            .withValues(alpha: 0.9), // Slightly darker for text
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
