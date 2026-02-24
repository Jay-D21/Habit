import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../core/providers/habit_providers.dart';
import '../../../../core/providers/habit_notifier.dart';
import '../../data/models/habit.dart';
import '../../../../core/services/ad_service.dart';
import '../../../../core/models/priority_enum.dart';

class HabitCard extends ConsumerStatefulWidget {
  final Habit habit;
  final bool compact; // For tighter lists

  const HabitCard({
    super.key,
    required this.habit,
    this.compact = false,
  });

  @override
  ConsumerState<HabitCard> createState() => _HabitCardState();
}

class _HabitCardState extends ConsumerState<HabitCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final isCompleted =
        ref.watch(isHabitCompletedTodayProvider(widget.habit.id!));
    final completionCount =
        ref.watch(habitCompletionCountTodayProvider(widget.habit.id!));
    final hasProgress = widget.habit.targetCount > 1;

    // Parse habit color
    Color habitColor;
    try {
      habitColor = Color(int.parse(widget.habit.colorHex, radix: 16));
    } catch (_) {
      habitColor = AppColors.primary;
    }

    // Boost visuals for high priority
    final priority = HabitPriority.fromValue(widget.habit.priority);
    final isHighPriority = priority.value >= 4;

    return GestureDetector(
      onTap: () {
        context.push('/habits/${widget.habit.id!}');
      },
      onLongPressStart: (_) {
        setState(() => _isPressed = true);
        HapticFeedback.mediumImpact();
      },
      onLongPressEnd: (_) async {
        setState(() => _isPressed = false);
        HapticFeedback.heavyImpact();
        await ref
            .read(habitNotifierProvider.notifier)
            .toggleHabit(widget.habit.id!);
        // Track for ad frequency (show after 2 completions)
        ref.read(adFrequencyProvider.notifier).onHabitCompleted(ref);
      },
      onLongPressCancel: () {
        setState(() => _isPressed = false);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        transform: _isPressed
            ? Matrix4.diagonal3Values(0.98, 0.98, 1.0)
            : Matrix4.identity(),
        padding: const EdgeInsets.all(AppTheme.spacingLg),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: isHighPriority
                  ? priority.color.withValues(alpha: isDark ? 0.15 : 0.05)
                  : Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
              blurRadius: isHighPriority ? 20 : 16,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: isHighPriority && !isCompleted
                ? priority.color.withValues(alpha: 0.3)
                : (isDark
                    ? Colors.white.withValues(alpha: 0.05)
                    : Colors.transparent),
            width: isHighPriority && !isCompleted ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            // Emoji Container
            Container(
              width: widget.compact ? 40 : 50,
              height: widget.compact ? 40 : 50,
              decoration: BoxDecoration(
                color: habitColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Text(
                      widget.habit.emoji,
                      style: TextStyle(fontSize: widget.compact ? 22 : 26),
                    ),
                  ),
                  if (widget.habit.isTimed)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.timer,
                          size: 12,
                          color: habitColor,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(
                width:
                    widget.compact ? AppTheme.spacingMd : AppTheme.spacingMd),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          widget.habit.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            decoration: isCompleted && !hasProgress
                                ? TextDecoration.lineThrough
                                : null,
                            color: isCompleted && !hasProgress
                                ? theme.colorScheme.onSurface
                                    .withValues(alpha: 0.5)
                                : theme.colorScheme.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // Priority Stars
                      if (priority.value > 1) ...[
                        const SizedBox(width: 6),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(
                            priority.value,
                            (index) => Icon(
                              Icons.star_rounded,
                              size: 14,
                              color: priority.color,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  if (hasProgress) ...[
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: (widget.habit.targetCount > 0)
                                  ? (completionCount / widget.habit.targetCount)
                                      .clamp(0.0, 1.0)
                                  : 0.0,
                              backgroundColor: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.08),
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(habitColor),
                              minHeight: 6,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '$completionCount/${widget.habit.targetCount}',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.6),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    Text(
                      widget.habit.category.name[0].toUpperCase() +
                          widget.habit.category.name.substring(1),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(width: AppTheme.spacingMd),

            // Checkbox Button
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  HapticFeedback.lightImpact();
                  debugPrint('🎯 Habit checkbox tapped: ${widget.habit.name}');
                  ref
                      .read(habitNotifierProvider.notifier)
                      .toggleHabit(widget.habit.id!);
                  // Track for ad frequency (show after 2 completions)
                  ref.read(adFrequencyProvider.notifier).onHabitCompleted(ref);
                },
                borderRadius: BorderRadius.circular(12),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.elasticOut,
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isCompleted ? habitColor : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isCompleted
                          ? habitColor
                          : theme.colorScheme.onSurface.withValues(alpha: 0.2),
                      width: 2,
                    ),
                  ),
                  child: isCompleted
                      ? const Icon(
                          Icons.check_rounded,
                          size: 20,
                          color: Colors.white,
                        )
                          .animate()
                          .scale(duration: 200.ms, curve: Curves.easeOutBack)
                      : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
