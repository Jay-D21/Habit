import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/dnd_service.dart';
import '../services/habit_timer_service.dart';

// --- DND Service Provider ---
final dndServiceProvider = Provider<DndService>((ref) => DndService());

// --- Timer Service Provider ---
final habitTimerServiceProvider = Provider<HabitTimerService>((ref) {
  final dndService = ref.watch(dndServiceProvider);
  return HabitTimerService(dndService);
});

// --- Timer State ---
class TimerState {
  final int initialDuration;
  final int remainingSeconds;
  final bool isRunning;
  final int? activeHabitId;

  const TimerState({
    this.initialDuration = 0,
    this.remainingSeconds = 0,
    this.isRunning = false,
    this.activeHabitId,
  });

  TimerState copyWith({
    int? initialDuration,
    int? remainingSeconds,
    bool? isRunning,
    int? activeHabitId,
  }) {
    return TimerState(
      initialDuration: initialDuration ?? this.initialDuration,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      isRunning: isRunning ?? this.isRunning,
      activeHabitId: activeHabitId ?? this.activeHabitId,
    );
  }

  double get progress {
    if (initialDuration == 0) return 0.0;
    return remainingSeconds / initialDuration;
  }
}

// --- Timer Notifier ---
class HabitTimerNotifier extends Notifier<TimerState> {
  @override
  TimerState build() {
    return const TimerState();
  }

  void startTimer(int habitId, int minutes) {
    if (state.isRunning) return; // Prevent multiple timers

    final durationInSeconds = minutes * 60;
    state = TimerState(
      initialDuration: durationInSeconds,
      remainingSeconds: durationInSeconds,
      isRunning: true,
      activeHabitId: habitId,
    );

    final service = ref.read(habitTimerServiceProvider);
    service.startTimer(
      durationInSeconds: durationInSeconds,
      onTick: (remaining) {
        state = state.copyWith(remainingSeconds: remaining);
      },
      onFinish: () {
        state = state.copyWith(isRunning: false, remainingSeconds: 0);
        // We will handle completion logic in the UI or listen to this state change
      },
    );
  }

  void stopTimer() {
    final service = ref.read(habitTimerServiceProvider);
    service.stopTimer();
    state = state.copyWith(isRunning: false);
  }

  /// Called when user gives up or navigates away explicitly cancelling
  void cancelTimer() {
     stopTimer();
     state = const TimerState();
  }
}

final habitTimerProvider = NotifierProvider<HabitTimerNotifier, TimerState>(() {
  return HabitTimerNotifier();
});
