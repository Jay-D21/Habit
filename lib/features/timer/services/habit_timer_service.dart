import 'dart:async';
import '../../../core/services/dnd_service.dart';

class HabitTimerService {
  final DndService _dndService;
  Timer? _timer;

  HabitTimerService(this._dndService);

  void startTimer({
    required int durationInSeconds,
    required void Function(int remaining) onTick,
    required void Function() onFinish,
  }) async {
    // Enable DND
    await _dndService.enableDnd();

    int remaining = durationInSeconds;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      remaining--;
      if (remaining <= 0) {
        timer.cancel();
        stopTimer(); // Disable DND
        onFinish();
      } else {
        onTick(remaining);
      }
    });
  }

  void stopTimer() async {
    _timer?.cancel();
    _timer = null;
    await _dndService.disableDnd();
  }
}
