import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class DndService {
  static const MethodChannel _channel =
      MethodChannel('com.habittracker.habit_tracker/dnd');

  Future<bool> checkPermissions() async {
    try {
      final bool granted = await _channel.invokeMethod('checkPermissions');
      return granted;
    } on PlatformException catch (e) {
      debugPrint("Failed to check permissions: '${e.message}'.");
      return false;
    }
  }

  Future<void> requestPermissions() async {
    try {
      await _channel.invokeMethod('requestPermissions');
    } on PlatformException catch (e) {
      debugPrint("Failed to request permissions: '${e.message}'.");
    }
  }

  Future<void> enableDnd() async {
    try {
      await _channel.invokeMethod('enableDnd');
    } on PlatformException catch (e) {
      debugPrint("Failed to enable DND: '${e.message}'.");
    }
  }

  Future<void> disableDnd() async {
    try {
      await _channel.invokeMethod('disableDnd');
    } on PlatformException catch (e) {
      debugPrint("Failed to disable DND: '${e.message}'.");
    }
  }
}
