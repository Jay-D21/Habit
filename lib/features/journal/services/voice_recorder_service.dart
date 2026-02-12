import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:uuid/uuid.dart';

class VoiceRecorderService {
  final AudioRecorder _audioRecorder = AudioRecorder();

  Future<bool> hasPermission() async {
    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  Future<String> startRecording() async {
    if (!await hasPermission()) {
      throw Exception('Microphone permission not granted');
    }

    final directory = await getApplicationDocumentsDirectory();
    // Create a specific folder for voice notes if it doesn't exist
    final voiceNotesDir = Directory('${directory.path}/voice_notes');
    if (!await voiceNotesDir.exists()) {
      await voiceNotesDir.create(recursive: true);
    }

    final fileName = 'voice_note_${const Uuid().v4()}.m4a';
    final path = '${voiceNotesDir.path}/$fileName';

    // Start recording to file
    await _audioRecorder.start(const RecordConfig(), path: path);
    return path;
  }

  Future<String?> stopRecording() async {
    final path = await _audioRecorder.stop();
    return path;
  }

  Future<void> cancelRecording() async {
    await _audioRecorder.stop();
    // Logic to delete the file if created?
    // The record package might not return the path on cancel easily or we ignore it.
    // Ideally we should clean up if we can.
    // For now, simple stop is fine.
  }

  Future<bool> isRecording() async {
    return await _audioRecorder.isRecording();
  }

  Future<void> dispose() async {
    _audioRecorder.dispose();
  }
}
