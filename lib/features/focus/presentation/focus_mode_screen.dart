import 'dart:math' as math;
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:habit_tracker/core/database/database.dart';
import 'package:habit_tracker/main.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_theme.dart';
import '../providers/focus_providers.dart';
import '../services/focus_timer_service.dart';

// ─────────────────────────── Phase Config ───────────────────────────
class _PhaseConfig {
  final String label;
  final IconData icon;
  final Color color;
  final Color bgColor;

  const _PhaseConfig({
    required this.label,
    required this.icon,
    required this.color,
    required this.bgColor,
  });
}

final _phaseConfigs = {
  FocusPhase.focus: const _PhaseConfig(
    label: 'Focus',
    icon: Icons.psychology_rounded,
    color: AppColors.primary,
    bgColor: AppColors.primaryContainer,
  ),
  FocusPhase.shortBreak: const _PhaseConfig(
    label: 'Short Break',
    icon: Icons.coffee_rounded,
    color: AppColors.success,
    bgColor: AppColors.successContainer,
  ),
  FocusPhase.longBreak: const _PhaseConfig(
    label: 'Long Break',
    icon: Icons.self_improvement_rounded,
    color: AppColors.tertiary,
    bgColor: AppColors.tertiaryContainer,
  ),
};

// ─────────────────────────── Main Screen ────────────────────────────
class FocusModeScreen extends ConsumerStatefulWidget {
  const FocusModeScreen({super.key});

  @override
  ConsumerState<FocusModeScreen> createState() => _FocusModeScreenState();
}

class _FocusModeScreenState extends ConsumerState<FocusModeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final timerState = ref.watch(focusTimerProvider);
    final settingsAsync = ref.watch(focusSettingsProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final config = _phaseConfigs[timerState.currentPhase]!;

    // Calculate progress
    double progress = 0.0;
    int totalSeconds = 1;
    final settings = settingsAsync.value;
    if (settings != null) {
      final durationMap = {
        FocusPhase.focus: settings.focusDuration,
        FocusPhase.shortBreak: settings.shortBreakDuration,
        FocusPhase.longBreak: settings.longBreakDuration,
      };
      totalSeconds = (durationMap[timerState.currentPhase] ?? 25) * 60;
      if (totalSeconds > 0) {
        progress = 1.0 - (timerState.remainingSeconds / totalSeconds);
      }
    }

    final minutes =
        (timerState.remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds =
        (timerState.remainingSeconds % 60).toString().padLeft(2, '0');

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : config.bgColor.withValues(alpha: 0.15),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Focus Mode'),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_rounded),
            onPressed: () => _showSettingsSheet(context, settings),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: AppTheme.spacingLg),

            // Phase Chips
            _PhaseChips(
              currentPhase: timerState.currentPhase,
              onPhaseSelected: (phase) {
                // Only allow switching when stopped
                if (timerState.status == TimerStatus.initial ||
                    timerState.status == TimerStatus.finished) {
                  ref.read(focusTimerProvider.notifier).switchPhase(phase);
                }
              },
            ),

            // Timer Display
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Animated Timer Ring
                    AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, child) {
                        final pulseScale =
                            timerState.status == TimerStatus.running
                                ? 1.0 + (_pulseController.value * 0.015)
                                : 1.0;
                        return Transform.scale(
                          scale: pulseScale,
                          child: child,
                        );
                      },
                      child: SizedBox(
                        width: 280,
                        height: 280,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Background ring
                            SizedBox.expand(
                              child: CustomPaint(
                                painter: _GradientRingPainter(
                                  progress: progress,
                                  color: config.color,
                                  backgroundColor: config.color
                                      .withValues(alpha: isDark ? 0.15 : 0.1),
                                ),
                              ),
                            ),
                            // Timer text
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(config.icon,
                                    size: 28,
                                    color: config.color.withValues(alpha: 0.7)),
                                const SizedBox(height: 4),
                                Text(
                                  '$minutes:$seconds',
                                  style: GoogleFonts.outfit(
                                    fontSize: 56,
                                    fontWeight: FontWeight.w700,
                                    color: theme.colorScheme.onSurface,
                                    letterSpacing: 2,
                                  ),
                                ),
                                Text(
                                  config.label,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: config.color,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: AppTheme.spacingXl),

                    // Session dots
                    _SessionDots(
                      completed: timerState.pomodorosCompleted,
                      total: settings?.longBreakInterval ?? 4,
                      accentColor: config.color,
                    ),

                    const SizedBox(height: AppTheme.spacingXl),

                    // Controls
                    _TimerControls(
                      status: timerState.status,
                      phaseColor: config.color,
                      onStart: () =>
                          ref.read(focusTimerProvider.notifier).startTimer(),
                      onPause: () =>
                          ref.read(focusTimerProvider.notifier).pauseTimer(),
                      onStop: () =>
                          ref.read(focusTimerProvider.notifier).stopTimer(),
                      onSkip: () =>
                          ref.read(focusTimerProvider.notifier).skipPhase(),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom stats
            Padding(
              padding: const EdgeInsets.only(bottom: AppTheme.spacingXl),
              child: Text(
                '${timerState.pomodorosCompleted} pomodoro${timerState.pomodorosCompleted == 1 ? '' : 's'} completed today',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSettingsSheet(BuildContext context, FocusSettingsData? settings) {
    if (settings == null) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _FocusSettingsSheet(initialSettings: settings),
    );
  }
}

// ─────────────────────────── Phase Chips ────────────────────────────
class _PhaseChips extends StatelessWidget {
  final FocusPhase currentPhase;
  final ValueChanged<FocusPhase> onPhaseSelected;

  const _PhaseChips({
    required this.currentPhase,
    required this.onPhaseSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingXl),
      child: Row(
        children: FocusPhase.values.map((phase) {
          final config = _phaseConfigs[phase]!;
          final isSelected = phase == currentPhase;
          return Expanded(
            child: GestureDetector(
              onTap: () => onPhaseSelected(phase),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                decoration: BoxDecoration(
                  color: isSelected
                      ? config.color.withValues(alpha: 0.15)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                  border: Border.all(
                    color: isSelected
                        ? config.color.withValues(alpha: 0.4)
                        : theme.colorScheme.outline.withValues(alpha: 0.15),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(config.icon,
                        size: 18,
                        color: isSelected
                            ? config.color
                            : theme.colorScheme.onSurface
                                .withValues(alpha: 0.4)),
                    const SizedBox(height: 2),
                    Text(
                      config.label,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: isSelected
                            ? config.color
                            : theme.colorScheme.onSurface
                                .withValues(alpha: 0.4),
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.normal,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─────────────────────────── Session Dots ───────────────────────────
class _SessionDots extends StatelessWidget {
  final int completed;
  final int total;
  final Color accentColor;

  const _SessionDots({
    required this.completed,
    required this.total,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final activeDots = completed % total;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (i) {
        final isFilled = i < activeDots;
        return Container(
          width: 10,
          height: 10,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isFilled ? accentColor : accentColor.withValues(alpha: 0.2),
            border: Border.all(
              color: accentColor.withValues(alpha: 0.4),
              width: 1.5,
            ),
          ),
        );
      }),
    );
  }
}

// ─────────────────────────── Controls ───────────────────────────────
class _TimerControls extends StatelessWidget {
  final TimerStatus status;
  final Color phaseColor;
  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onStop;
  final VoidCallback onSkip;

  const _TimerControls({
    required this.status,
    required this.phaseColor,
    required this.onStart,
    required this.onPause,
    required this.onStop,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Stop
        _ControlButton(
          icon: Icons.stop_rounded,
          label: 'Reset',
          color: theme.colorScheme.error,
          onTap: onStop,
          size: 44,
        ),
        const SizedBox(width: AppTheme.spacingLg),

        // Play / Pause (main action)
        GestureDetector(
          onTap: status == TimerStatus.running ? onPause : onStart,
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [phaseColor, phaseColor.withValues(alpha: 0.7)],
              ),
              boxShadow: [
                BoxShadow(
                  color: phaseColor.withValues(alpha: 0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Icon(
              status == TimerStatus.running
                  ? Icons.pause_rounded
                  : Icons.play_arrow_rounded,
              color: Colors.white,
              size: 36,
            ),
          ),
        ),
        const SizedBox(width: AppTheme.spacingLg),

        // Skip
        _ControlButton(
          icon: Icons.skip_next_rounded,
          label: 'Skip',
          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          onTap: onSkip,
          size: 44,
        ),
      ],
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final double size;

  const _ControlButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: 0.1),
              border: Border.all(color: color.withValues(alpha: 0.3)),
            ),
            child: Icon(icon, color: color, size: size * 0.5),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: color,
                  fontSize: 10,
                ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────── Gradient Ring ──────────────────────────
class _GradientRingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color backgroundColor;

  _GradientRingPainter({
    required this.progress,
    required this.color,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 14) / 2;
    const strokeWidth = 10.0;

    // Background ring
    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc
    if (progress > 0) {
      final sweepAngle = 2 * math.pi * progress;
      final rect = Rect.fromCircle(center: center, radius: radius);
      final progressPaint = Paint()
        ..shader = SweepGradient(
          startAngle: -math.pi / 2,
          endAngle: -math.pi / 2 + sweepAngle,
          colors: [color.withValues(alpha: 0.6), color],
          stops: const [0.0, 1.0],
        ).createShader(rect)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        rect,
        -math.pi / 2,
        sweepAngle,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _GradientRingPainter old) =>
      old.progress != progress ||
      old.color != color ||
      old.backgroundColor != backgroundColor;
}

// ─────────────────────── Enhanced Settings Sheet ────────────────────
class _FocusSettingsSheet extends ConsumerStatefulWidget {
  final FocusSettingsData initialSettings;
  const _FocusSettingsSheet({required this.initialSettings});

  @override
  ConsumerState<_FocusSettingsSheet> createState() =>
      _FocusSettingsSheetState();
}

class _FocusSettingsSheetState extends ConsumerState<_FocusSettingsSheet> {
  late int _focusDuration;
  late int _shortBreak;
  late int _longBreak;
  late int _longBreakInterval;
  late bool _autoStartPomodoros;
  late bool _autoStartBreaks;

  @override
  void initState() {
    super.initState();
    _focusDuration = widget.initialSettings.focusDuration;
    _shortBreak = widget.initialSettings.shortBreakDuration;
    _longBreak = widget.initialSettings.longBreakDuration;
    _longBreakInterval = widget.initialSettings.longBreakInterval;
    _autoStartPomodoros = widget.initialSettings.autoStartPomodoros;
    _autoStartBreaks = widget.initialSettings.autoStartBreaks;
  }

  Future<void> _save() async {
    final newSettings = FocusSettingsCompanion(
      focusDuration: drift.Value(_focusDuration),
      shortBreakDuration: drift.Value(_shortBreak),
      longBreakDuration: drift.Value(_longBreak),
      longBreakInterval: drift.Value(_longBreakInterval),
      autoStartPomodoros: drift.Value(_autoStartPomodoros),
      autoStartBreaks: drift.Value(_autoStartBreaks),
    );
    await database.updateFocusSettings(newSettings);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: AppTheme.spacingLg),
          Text('Timer Settings',
              style: theme.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: AppTheme.spacingXl),

          // Duration pickers
          _DurationPicker(
            label: 'Focus Duration',
            icon: Icons.psychology_rounded,
            color: AppColors.primary,
            value: _focusDuration,
            min: 1,
            max: 90,
            onChanged: (v) => setState(() => _focusDuration = v),
          ),
          const SizedBox(height: AppTheme.spacingMd),
          _DurationPicker(
            label: 'Short Break',
            icon: Icons.coffee_rounded,
            color: AppColors.success,
            value: _shortBreak,
            min: 1,
            max: 30,
            onChanged: (v) => setState(() => _shortBreak = v),
          ),
          const SizedBox(height: AppTheme.spacingMd),
          _DurationPicker(
            label: 'Long Break',
            icon: Icons.self_improvement_rounded,
            color: AppColors.tertiary,
            value: _longBreak,
            min: 1,
            max: 60,
            onChanged: (v) => setState(() => _longBreak = v),
          ),
          const SizedBox(height: AppTheme.spacingMd),
          _DurationPicker(
            label: 'Sessions before long break',
            icon: Icons.repeat_rounded,
            color: AppColors.accent,
            value: _longBreakInterval,
            min: 2,
            max: 8,
            suffix: '',
            onChanged: (v) => setState(() => _longBreakInterval = v),
          ),

          const SizedBox(height: AppTheme.spacingLg),

          // Toggles
          _ToggleTile(
            label: 'Auto-start Pomodoros',
            value: _autoStartPomodoros,
            onChanged: (v) => setState(() => _autoStartPomodoros = v),
          ),
          _ToggleTile(
            label: 'Auto-start Breaks',
            value: _autoStartBreaks,
            onChanged: (v) => setState(() => _autoStartBreaks = v),
          ),

          const SizedBox(height: AppTheme.spacingXl),

          // Save button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: FilledButton(
              onPressed: _save,
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                ),
              ),
              child: const Text('Save Settings'),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────── Duration Picker (tap to edit) ─────────────────────
class _DurationPicker extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final int value;
  final int min;
  final int max;
  final String suffix;
  final ValueChanged<int> onChanged;

  const _DurationPicker({
    required this.label,
    required this.icon,
    required this.color,
    required this.value,
    required this.min,
    required this.max,
    this.suffix = 'min',
    required this.onChanged,
  });

  void _showEditDialog(BuildContext context) {
    final controller = TextEditingController(text: value.toString());
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(label),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          autofocus: true,
          decoration: InputDecoration(
            suffixText: suffix.isEmpty ? null : suffix,
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final parsed = int.tryParse(controller.text) ?? value;
              onChanged(parsed.clamp(min, max));
              Navigator.pop(ctx);
            },
            child: const Text('Set'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: color),
        ),
        const SizedBox(width: AppTheme.spacingSm),
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodyMedium,
          ),
        ),
        // Minus
        _StepButton(
          icon: Icons.remove,
          onTap: value > min ? () => onChanged(value - 1) : null,
        ),
        // Value (tappable)
        GestureDetector(
          onTap: () => _showEditDialog(context),
          child: Container(
            width: 52,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest
                  .withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              suffix.isNotEmpty ? '$value' : '$value',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        // Plus
        _StepButton(
          icon: Icons.add,
          onTap: value < max ? () => onChanged(value + 1) : null,
        ),
      ],
    );
  }
}

class _StepButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _StepButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: onTap != null
              ? theme.colorScheme.surfaceContainerHighest
              : Colors.transparent,
        ),
        child: Icon(
          icon,
          size: 16,
          color: onTap != null
              ? theme.colorScheme.onSurface
              : theme.colorScheme.onSurface.withValues(alpha: 0.2),
        ),
      ),
    );
  }
}

// ───────────────────── Toggle Tile ──────────────────────────────────
class _ToggleTile extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleTile({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.bodyMedium),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
