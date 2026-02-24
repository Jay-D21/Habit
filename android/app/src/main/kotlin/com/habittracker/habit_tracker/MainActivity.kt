package com.habittracker.habit_tracker

import android.app.NotificationManager
import android.content.Context
import android.content.Intent
import android.os.Build
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.habittracker.habit_tracker/dnd"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

            if (call.method == "checkPermissions") {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                    result.success(notificationManager.isNotificationPolicyAccessGranted)
                } else {
                    result.success(true)
                }
            } else if (call.method == "requestPermissions") {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M && !notificationManager.isNotificationPolicyAccessGranted) {
                    val intent = Intent(Settings.ACTION_NOTIFICATION_POLICY_ACCESS_SETTINGS)
                    startActivity(intent)
                    result.success(false)
                } else {
                    result.success(true)
                }
            } else if (call.method == "enableDnd") {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                    if (notificationManager.isNotificationPolicyAccessGranted) {
                        notificationManager.setInterruptionFilter(NotificationManager.INTERRUPTION_FILTER_PRIORITY)
                        result.success(true)
                    } else {
                        result.error("PERMISSION_DENIED", "Notification policy access not granted", null)
                    }
                } else {
                    result.success(true)
                }
            } else if (call.method == "disableDnd") {
                 if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                    if (notificationManager.isNotificationPolicyAccessGranted) {
                        notificationManager.setInterruptionFilter(NotificationManager.INTERRUPTION_FILTER_ALL)
                        result.success(true)
                    } else {
                        result.error("PERMISSION_DENIED", "Notification policy access not granted", null)
                    }
                } else {
                    result.success(true)
                }
            } else {
                result.notImplemented()
            }
        }
    }
}
