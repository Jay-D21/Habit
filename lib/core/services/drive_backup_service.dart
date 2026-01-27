import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:archive/archive_io.dart';
import 'package:path/path.dart' as path;
import '../../main.dart'; // For database instance
import 'auth_service.dart';

final driveBackupServiceProvider = Provider<DriveBackupService>((ref) {
  return DriveBackupService(ref);
});

class DriveBackupService {
  final Ref _ref;
  static const String _backupFileName = 'habit_tracker_backup.zip';
  static const String _lastBackupKey = 'last_backup_timestamp';
  static const String _dbFileName = 'habit_tracker.db';

  DriveBackupService(this._ref);

  Future<drive.DriveApi?> _getDriveApi() async {
    final authNotifier = _ref.read(authProvider.notifier);
    final googleSignIn = authNotifier.googleSignIn;

    // Check if signed in
    if (googleSignIn.currentUser == null) {
      debugPrint('DriveBackup: No signed in user');
      return null;
    }

    try {
      // Try to get authenticated client
      final client = await googleSignIn.authenticatedClient();
      if (client == null) {
        debugPrint(
            'DriveBackup: Failed to get authenticated client - user may need to re-sign in');
        return null;
      }
      return drive.DriveApi(client);
    } catch (e) {
      debugPrint('DriveBackup: Error getting Drive API - $e');
      return null;
    }
  }

  /// Perform automatic backup if needed (once every 24h)
  Future<void> autoBackupOrSync() async {
    // Only auto-backup if user is signed in
    final googleSignIn = _ref.read(authProvider.notifier).googleSignIn;
    if (googleSignIn.currentUser == null) {
      debugPrint('Auto-backup skipped: user not signed in');
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final lastBackupStr = prefs.getString(_lastBackupKey);
    final lastBackup =
        lastBackupStr != null ? DateTime.parse(lastBackupStr) : null;

    // Check if backup is needed (older than 24h or never done)
    if (lastBackup == null ||
        DateTime.now().difference(lastBackup).inHours >= 24) {
      debugPrint('Auto-backup triggered');
      await backup();
    }
  }

  /// Upload a backup of the local database to Google Drive App Data folder
  Future<bool> backup() async {
    try {
      debugPrint('DriveBackup: Starting backup...');

      final driveApi = await _getDriveApi();
      if (driveApi == null) {
        debugPrint(
            'DriveBackup: Could not get Drive API - please sign out and sign in again');
        return false;
      }

      // 1. Locate the local SQLite database
      final dir = await getApplicationDocumentsDirectory();
      final dbPath = path.join(dir.path, _dbFileName);
      final backupPath = path.join(dir.path, 'backup_temp.db');

      if (!File(dbPath).existsSync()) {
        debugPrint('DriveBackup: Database file not found at $dbPath');
        return false;
      }

      debugPrint('DriveBackup: Copying SQLite database...');

      // Copy database file
      if (File(backupPath).existsSync()) {
        File(backupPath).deleteSync();
      }
      // Simple copy (best effort for hot backup)
      File(dbPath).copySync(backupPath);

      // Also try to copy WAL/SHM files if they exist (for complete consistency if DB is busy)
      // For simplicity in this migration, we stick to the main DB file
      // SQLite often merges freely, but main file is key.

      // 2. Zip the file
      debugPrint('DriveBackup: Creating zip archive...');
      final zipPath = path.join(dir.path, 'backup.zip');
      final encoder = ZipFileEncoder();
      encoder.create(zipPath);
      encoder.addFile(File(backupPath), _dbFileName);
      encoder.close();

      // Clean up temp file
      File(backupPath).deleteSync();

      // 3. Check for existing backup in Drive App Data
      debugPrint('DriveBackup: Checking for existing backup in Drive...');
      final fileList = await driveApi.files.list(
        q: "name = '$_backupFileName' and 'appDataFolder' in parents and trashed = false",
        $fields: 'files(id, createdTime)',
        spaces: 'appDataFolder',
      );

      final uploadFile = drive.File();
      uploadFile.name = _backupFileName;
      uploadFile.parents = ['appDataFolder'];

      final localFile = File(zipPath);
      final media = drive.Media(localFile.openRead(), localFile.lengthSync());

      debugPrint(
          'DriveBackup: Uploading to Drive (${localFile.lengthSync()} bytes)...');

      if (fileList.files != null && fileList.files!.isNotEmpty) {
        // Update existing file
        final fileId = fileList.files!.first.id!;
        await driveApi.files.update(
          uploadFile,
          fileId,
          uploadMedia: media,
        );
        debugPrint('DriveBackup: Updated existing backup');
      } else {
        // Create new file
        await driveApi.files.create(
          uploadFile,
          uploadMedia: media,
        );
        debugPrint('DriveBackup: Created new backup');
      }

      // Cleanup zip
      localFile.deleteSync();

      // Update timestamp
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_lastBackupKey, DateTime.now().toIso8601String());

      debugPrint('DriveBackup: Backup successful!');
      return true;
    } catch (e, stackTrace) {
      debugPrint('DriveBackup: Backup failed - $e');
      debugPrint('Stack trace: $stackTrace');
      return false;
    }
  }

  /// Restore from the latest backup in Google Drive
  /// Returns true if successful. Caller must invoke Restart.
  Future<bool> restore() async {
    try {
      final driveApi = await _getDriveApi();
      if (driveApi == null) return false;

      // 1. Find backup file
      final fileList = await driveApi.files.list(
        q: "name = '$_backupFileName' and 'appDataFolder' in parents and trashed = false",
        $fields: 'files(id, size)',
        spaces: 'appDataFolder',
      );

      if (fileList.files == null || fileList.files!.isEmpty) {
        return false; // No backup found
      }

      final fileId = fileList.files!.first.id!;

      // 2. Download zip
      final driveFile = await driveApi.files.get(
        fileId,
        downloadOptions: drive.DownloadOptions.fullMedia,
      ) as drive.Media;

      final dir = await getApplicationDocumentsDirectory();
      final zipPath = path.join(dir.path, 'restore_temp.zip');
      final saveFile = File(zipPath);

      final List<int> dataStore = [];
      await driveFile.stream.forEach((data) {
        dataStore.addAll(data);
      });
      await saveFile.writeAsBytes(dataStore);

      // 3. Unzip
      final bytes = saveFile.readAsBytesSync();
      final archive = ZipDecoder().decodeBytes(bytes);

      bool foundDb = false;
      for (final file in archive) {
        if (file.name == _dbFileName) {
          // Extract to temp location
          final data = file.content as List<int>;
          File(path.join(dir.path, 'restored.db'))
            ..createSync(recursive: true)
            ..writeAsBytesSync(data);
          foundDb = true;
          break;
        }
      }

      saveFile.deleteSync(); // Delete zip

      if (!foundDb) return false;

      // 4. Replace Database
      // CRITICAL: We must close Database before replacing the file
      await database.close();

      final currentDbPath = path.join(dir.path, _dbFileName);
      final restoredDbPath = path.join(dir.path, 'restored.db');

      if (File(currentDbPath).existsSync()) {
        File(currentDbPath).deleteSync();
      }

      // Also delete WAL/SHM if they exist
      if (File('$currentDbPath-wal').existsSync()) {
        File('$currentDbPath-wal').deleteSync();
      }
      if (File('$currentDbPath-shm').existsSync()) {
        File('$currentDbPath-shm').deleteSync();
      }

      // Move restored file to default location
      File(restoredDbPath).renameSync(currentDbPath);

      // Note: Caller must restart app to re-open Database
      return true;
    } catch (e) {
      debugPrint('Restore failed: $e');
      return false;
    }
  }

  /// Check if a backup exists in Drive
  Future<DateTime?> getLastCloudBackupTime() async {
    try {
      final driveApi = await _getDriveApi();
      if (driveApi == null) return null;

      final fileList = await driveApi.files.list(
        q: "name = '$_backupFileName' and 'appDataFolder' in parents and trashed = false",
        $fields: 'files(id, modifiedTime)',
        spaces: 'appDataFolder',
      );

      if (fileList.files != null && fileList.files!.isNotEmpty) {
        return fileList.files!.first.modifiedTime;
      }
      return null;
    } catch (e) {
      debugPrint('Check backup failed: $e');
      return null;
    }
  }
}
