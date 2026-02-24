import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/providers/habit_notifier.dart';
import '../../../../core/providers/habit_providers.dart';
import '../../timer/providers/habit_timer_providers.dart';

class HabitTimerScreen extends ConsumerStatefulWidget {
  final String habitId;

  const HabitTimerScreen({
    super.key,
    required this.habitId,
  });

  @override
  ConsumerState<HabitTimerScreen> createState() => _HabitTimerScreenState();
}

class _HabitTimerScreenState extends ConsumerState<HabitTimerScreen>
    with SingleTickerProviderStateMixin {
  late int _habitId;

  @override
  void initState() {
    super.initState();
    _habitId = int.parse(widget.habitId);
    WakelockPlus.enable(); // Keep screen on
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    super.dispose();
  }

  String _formatTime(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final timerState = ref.watch(habitTimerProvider);
    final habitAsync = ref.watch(habitProvider(_habitId));

    // Listen for completion
    ref.listen(habitTimerProvider, (prev, next) {
      if (prev?.isRunning == true &&
          !next.isRunning &&
          next.remainingSeconds == 0) {
        // Timer finished naturally
        _onTimerFinished();
      }
    });

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _confirmExit(context);
      },
      child: Scaffold(
        backgroundColor:
            isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
        body: habitAsync.when(
          data: (habit) {
            if (habit == null) {
              return const Center(child: Text('Habit not found'));
            }

            final color = Color(int.parse(habit.colorHex, radix: 16));
            final progress = timerState.initialDuration > 0
                ? timerState.remainingSeconds / timerState.initialDuration
                : 0.0;

            return SafeArea(
              child: Stack(
                children: [
                  // Background Circle Animation (Simplified)
                  Positioned.fill(
                    child: Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.width * 0.8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: color.withValues(alpha: 0.05),
                        ),
                      ),
                    ),
                  ),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Top Bar
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () => _confirmExit(context),
                              icon: const Icon(Icons.close_rounded, size: 32),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: color.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.do_not_disturb_on_rounded,
                                      size: 16, color: color),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Focus Mode On',
                                    style: TextStyle(
                                      color: color,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Timer Content
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            habit.emoji,
                            style: const TextStyle(fontSize: 64),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            habit.name,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 48),

                          // Timer Display
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                width: 280,
                                height: 280,
                                child: CircularProgressIndicator(
                                  value: progress,
                                  strokeWidth: 12,
                                  backgroundColor: theme.colorScheme.onSurface
                                      .withValues(alpha: 0.1),
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(color),
                                  strokeCap: StrokeCap.round,
                                ),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    _formatTime(timerState.remainingSeconds),
                                    style: const TextStyle(
                                      fontSize: 64,
                                      fontWeight: FontWeight.bold,
                                      fontFeatures: [
                                        FontFeature.tabularFigures()
                                      ],
                                    ),
                                  ),
                                  Text(
                                    'remaining',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.onSurface
                                          .withValues(alpha: 0.5),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),

                      // Bottom Controls
                      Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          children: [
                            Text(
                              '"Stay focused, you got this!"',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontStyle: FontStyle.italic,
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.6),
                              ),
                            ),
                            const SizedBox(height: 32),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton(
                                onPressed: () => _confirmExit(context),
                                style: OutlinedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  side: BorderSide(
                                      color: theme.colorScheme.error),
                                  foregroundColor: theme.colorScheme.error,
                                ),
                                child: const Text('Give Up'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
        ),
      ),
    );
  }

  void _confirmExit(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Stop Timer?'),
        content: const Text(
            'If you stop now, the habit won\'t be marked as complete.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Keep Going'),
          ),
          TextButton(
            onPressed: () {
              ref.read(habitTimerProvider.notifier).cancelTimer();
              Navigator.pop(context); // Dialog
              context.pop(); // Screen
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Stop'),
          ),
        ],
      ),
    );
  }

  Future<void> _onTimerFinished() async {
    // 1. Mark habit as complete
    await ref.read(habitNotifierProvider.notifier).completeHabit(_habitId);

    // 2. Play sound/vibrate (handled by notification/system usually, but we can do haptics)
    HapticFeedback.heavyImpact();

    if (!mounted) return;

    // 3. Show success dialog
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('🎉 Nice work!'),
        content:
            const Text('You focused for the full duration. Habit completed!'),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              context.pop(); // Go back to detail/home
            },
            child: const Text('Awesome'),
          ),
        ],
      ),
    );
  }
}
