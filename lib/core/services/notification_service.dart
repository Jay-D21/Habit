import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../../features/habits/data/models/habit.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        // Handle notification tap
      },
    );
  }

  Future<bool> requestPermissions() async {
    final bool? androidGranted = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    return androidGranted ?? false;
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'habit_channel',
          'Habit Reminders',
          channelDescription: 'Notifications for habit reminders',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents:
          DateTimeComponents.time, // Repeat daily at this time
    );
  }

  /// Schedule a notification for a habit
  ///
  /// [habitId] - The ID of the habit
  /// [habitName] - The name of the habit (for notification title)
  /// [reminderTime] - The time string (HH:mm)
  /// [frequency] - The frequency of the habit
  /// [customDays] - List of custom days (1-7, Mon-Sun) if frequency is custom
  Future<void> scheduleHabitNotification({
    required int habitId,
    required String habitName,
    required String reminderTime,
    required HabitFrequency frequency,
    List<int>? customDays,
  }) async {
    final timeParts = reminderTime.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);

    final now = DateTime.now();
    var scheduledDate = DateTime(now.year, now.month, now.day, hour, minute);

    // If time has passed today, schedule for tomorrow (as a base)
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    // Determine repeating component
    // Note: Flutter Local Notifications handles daily repeat easily.
    // Specific days require scheduling 7 weekly notifications or using matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime

    // For simplicity in MVP:
    // 1. Daily: Use daily repeat
    // 2. Weekdays/Weekends/Custom: Schedule weekly notifications for each active day

    // We'll use a unique ID for each day of the week for a habit
    // Format: habitId * 10 + dayOfWeek (1-7)
    // This allows up to 7 notifications per habit.

    // Cancel existing notifications for this habit first to clear old schedules
    await cancelHabitNotifications(habitId);

    // Helper to schedule for a specific day of week
    Future<void> scheduleForDay(int dayOfWeek) async {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        habitId * 10 + dayOfWeek,
        'Time to $habitName!',
        'Don\'t break your streak!',
        _nextInstanceOfDayAndTime(dayOfWeek, hour, minute),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'habit_channel',
            'Habit Reminders',
            channelDescription: 'Notifications for habit reminders',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      );
    }

    // Logic based on frequency
    // Assuming frequency.index values: 0=daily, 1=weekdays, 2=weekends, 3=custom

    // We need to import HabitFrequency or handle by index.
    // Let's assume passed frequency is an enum or we check index.
    // For now, let's implement basic daily scheduling and leave complex repeat for next step or refinement
    // UPDATE: Implemented simplified logic assuming standard enum

    // Standard Daily (simple daily repeat)
    // We use a different ID convention for simple daily: habitId * 10

    if (frequency == HabitFrequency.daily) {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        habitId * 10,
        'Time to $habitName!',
        'Don\'t break your streak!',
        _nextInstanceOfTime(hour, minute),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'habit_channel',
            'Habit Reminders',
            channelDescription: 'Notifications for habit reminders',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
      return;
    }

    // Weekdays (Mon=1 to Fri=5)
    else if (frequency == HabitFrequency.weekdays) {
      for (int i = 1; i <= 5; i++) {
        await scheduleForDay(i);
      }
    }
    // Weekends (Sat=6, Sun=7)
    else if (frequency == HabitFrequency.weekends) {
      await scheduleForDay(6);
      await scheduleForDay(7);
    }
    // Custom
    else if (frequency == HabitFrequency.custom && customDays != null) {
      for (int day in customDays) {
        await scheduleForDay(day);
      }
    }
  }

  Future<void> cancelHabitNotifications(int habitId) async {
    // Cancel daily ID
    await cancelNotification(habitId * 10);
    // Cancel day-specific IDs (1-7)
    for (int i = 1; i <= 7; i++) {
      await cancelNotification(habitId * 10 + i);
    }
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  tz.TZDateTime _nextInstanceOfDayAndTime(int day, int hour, int minute) {
    tz.TZDateTime scheduledDate = _nextInstanceOfTime(hour, minute);
    while (scheduledDate.weekday != day) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
