# Task: Timer Habit with Auto Focus Mode

## Overview
Add timed habit mode: user sets a duration, starts a countdown timer, device enters DND automatically, and habit auto-completes on finish.

## Checklist

### Database & Data Layer
- [ ] Add `isTimed` and `timerDurationMinutes` columns to `Habits` table
- [ ] Bump schema to v6 with migration
- [ ] Update `HabitModel` with new fields + `copyWith`
- [ ] Run `build_runner` to regenerate DB code

### Native DND Integration
- [ ] Add `ACCESS_NOTIFICATION_POLICY` permission to AndroidManifest
- [ ] Implement Kotlin `MethodChannel` handler in `MainActivity.kt`
- [ ] Create `DndService` (Flutter side)

### Timer Logic
- [ ] Create `HabitTimerService` (countdown + DND hooks)
- [ ] Create `habit_timer_providers.dart` (Riverpod providers)

### UI Implementation
- [ ] Add "Timed Habit" toggle + duration picker to `AddHabitSheet`
- [ ] Update `HabitDetailScreen` — "Start Timer" button for timed habits
- [ ] Create `HabitTimerScreen` (full-screen countdown UI)
- [ ] Update `HabitCard` — timer badge + long-press behavior
- [ ] Add `/habits/:habitId/timer` route to `router.dart`

### Notifier Updates
- [ ] Update `HabitNotifier.createHabit()` with timer params
- [ ] Update `_EditHabitSheet` to support timer fields

### Verification
- [ ] Run `build_runner`
- [ ] Run `flutter analyze` (0 issues)
- [ ] Manual test: simple habit still works
- [ ] Manual test: timed habit timer + DND + auto-complete
