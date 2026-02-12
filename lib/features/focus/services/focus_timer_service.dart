import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:habit_tracker/core/database/database.dart'; // For FocusSettingsData

enum FocusPhase {
  focus,
  shortBreak,
  longBreak,
}

enum TimerStatus {
  initial,
  running,
  paused,
  finished,
}

class FocusTimerService {
  Timer? _timer;

  // State variables
  final ValueNotifier<int> remainingSeconds = ValueNotifier(0);
  final ValueNotifier<FocusPhase> currentPhase =
      ValueNotifier(FocusPhase.focus);
  final ValueNotifier<TimerStatus> status = ValueNotifier(TimerStatus.initial);
  final ValueNotifier<int> pomodorosCompleted = ValueNotifier(0);

  // Settings (cached)
  FocusSettingsData? _settings;

  // Callback for completion (e.g., to play sound or show notification)
  VoidCallback? onTimerComplete;

  void updateSettings(FocusSettingsData settings) {
    _settings = settings;
    if (status.value == TimerStatus.initial) {
      resetTimer();
    }
  }

  void startTimer() {
    if (_timer != null && _timer!.isActive) return;

    if (remainingSeconds.value == 0 && status.value == TimerStatus.initial) {
      resetTimer();
    }

    status.value = TimerStatus.running;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
      } else {
        _handleTimerComplete();
      }
    });
  }

  void pauseTimer() {
    _timer?.cancel();
    status.value = TimerStatus.paused;
  }

  void stopTimer() {
    _timer?.cancel();
    status.value = TimerStatus.initial;
    resetTimer();
  }

  void skipPhase() {
    _timer?.cancel();
    _nextPhase();
  }

  /// Manually switch to a specific phase (only when stopped/initial)
  void switchPhase(FocusPhase phase) {
    if (status.value == TimerStatus.running) return;
    _timer?.cancel();
    currentPhase.value = phase;
    resetTimer();
  }

  void resetTimer() {
    if (_settings == null) return;

    int durationMinutes;
    switch (currentPhase.value) {
      case FocusPhase.focus:
        durationMinutes = _settings!.focusDuration;
        break;
      case FocusPhase.shortBreak:
        durationMinutes = _settings!.shortBreakDuration;
        break;
      case FocusPhase.longBreak:
        durationMinutes = _settings!.longBreakDuration;
        break;
    }
    remainingSeconds.value = durationMinutes * 60;
    status.value = TimerStatus.initial; // Ready to start
  }

  void _handleTimerComplete() {
    _timer?.cancel();
    status.value = TimerStatus.finished;
    onTimerComplete?.call();

    // Track completed pomodoros only after a focus session
    if (currentPhase.value == FocusPhase.focus) {
      pomodorosCompleted.value++;
    }

    _nextPhase();
  }

  void _nextPhase() {
    if (_settings == null) return;

    // Determine next phase
    if (currentPhase.value == FocusPhase.focus) {
      if (pomodorosCompleted.value > 0 &&
          pomodorosCompleted.value % _settings!.longBreakInterval == 0) {
        currentPhase.value = FocusPhase.longBreak;
      } else {
        currentPhase.value = FocusPhase.shortBreak;
      }
    } else {
      // After any break, go back to focus
      currentPhase.value = FocusPhase.focus;
    }

    resetTimer();

    // Auto-start logic
    bool shouldAutoStart = false;
    if (currentPhase.value == FocusPhase.focus) {
      shouldAutoStart = _settings!.autoStartPomodoros;
    } else {
      shouldAutoStart = _settings!.autoStartBreaks;
    }

    if (shouldAutoStart) {
      startTimer();
    }
  }

  void dispose() {
    _timer?.cancel();
    remainingSeconds.dispose();
    currentPhase.dispose();
    status.dispose();
    pomodorosCompleted.dispose();
  }
}
