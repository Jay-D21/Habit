import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_tracker/core/database/database.dart';
import 'package:habit_tracker/main.dart'; // for database, notificationService
import '../services/focus_timer_service.dart';

// Stream of settings (nullable when no row exists yet)
final focusSettingsProvider = StreamProvider<FocusSettingsData?>((ref) {
  return database.select(database.focusSettings).watchSingleOrNull();
});

// Timer Service Instance
final focusTimerServiceProvider = Provider<FocusTimerService>((ref) {
  final service = FocusTimerService();
  ref.onDispose(service.dispose);

  // Listen to settings changes and update service
  final settingsAsync = ref.watch(focusSettingsProvider);
  settingsAsync.whenData((settings) {
    if (settings != null) {
      service.updateSettings(settings);
    }
  });

  // Handle timer completion (e.g., play sound)
  service.onTimerComplete = () {
    // We can add notification logic here later
    // notificationService.showNotification(...)
  };

  return service;
});

// Timer State View Model
class FocusTimerState {
  final int remainingSeconds;
  final FocusPhase currentPhase;
  final TimerStatus status;
  final int pomodorosCompleted;

  FocusTimerState({
    required this.remainingSeconds,
    required this.currentPhase,
    required this.status,
    required this.pomodorosCompleted,
  });
}

// StateNotifier to expose Timer Service state
final focusTimerProvider =
    StateNotifierProvider<FocusTimerNotifier, FocusTimerState>((ref) {
  final service = ref.watch(focusTimerServiceProvider);
  return FocusTimerNotifier(service);
});

class FocusTimerNotifier extends StateNotifier<FocusTimerState> {
  final FocusTimerService _service;

  FocusTimerNotifier(this._service)
      : super(FocusTimerState(
          remainingSeconds: _service.remainingSeconds.value,
          currentPhase: _service.currentPhase.value,
          status: _service.status.value,
          pomodorosCompleted: _service.pomodorosCompleted.value,
        )) {
    // Listen to service value notifiers
    _service.remainingSeconds.addListener(_updateState);
    _service.currentPhase.addListener(_updateState);
    _service.status.addListener(_updateState);
    _service.pomodorosCompleted.addListener(_updateState);
  }

  void _updateState() {
    state = FocusTimerState(
      remainingSeconds: _service.remainingSeconds.value,
      currentPhase: _service.currentPhase.value,
      status: _service.status.value,
      pomodorosCompleted: _service.pomodorosCompleted.value,
    );
  }

  @override
  void dispose() {
    _service.remainingSeconds.removeListener(_updateState);
    _service.currentPhase.removeListener(_updateState);
    _service.status.removeListener(_updateState);
    _service.pomodorosCompleted.removeListener(_updateState);
    super.dispose();
  }

  // Expose service methods
  void startTimer() => _service.startTimer();
  void pauseTimer() => _service.pauseTimer();
  void stopTimer() => _service.stopTimer();
  void skipPhase() => _service.skipPhase();
  void resetTimer() => _service.resetTimer();
  void switchPhase(FocusPhase phase) => _service.switchPhase(phase);
}
