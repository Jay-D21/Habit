import 'package:drift/drift.dart';

/// Table to store Focus Mode (Pomodoro) settings
@DataClassName('FocusSettingsData')
class FocusSettings extends Table {
  /// Single row ID (we only need one row of settings)
  IntColumn get id => integer().autoIncrement()();

  /// Focus duration in minutes (default: 25)
  IntColumn get focusDuration => integer().withDefault(const Constant(25))();

  /// Short break duration in minutes (default: 5)
  IntColumn get shortBreakDuration =>
      integer().withDefault(const Constant(5))();

  /// Long break duration in minutes (default: 15)
  IntColumn get longBreakDuration =>
      integer().withDefault(const Constant(15))();

  /// Number of pomodoros before a long break (default: 4)
  IntColumn get longBreakInterval => integer().withDefault(const Constant(4))();

  /// Auto-start breaks? (default: false)
  BoolColumn get autoStartBreaks =>
      boolean().withDefault(const Constant(false))();

  /// Auto-start pomodoros? (default: false)
  BoolColumn get autoStartPomodoros =>
      boolean().withDefault(const Constant(false))();
}
