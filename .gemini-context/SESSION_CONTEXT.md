# Project & Session Context

## Current Project State
The project is a Flutter-based Habit Tracker application with an integrated Journal feature. Recent focus has been on:
1.  **Multi-Diary Architecture**: Refactoring the journal to support multiple separate diaries.
2.  **Navigation Robustness**: Fixing back-button issues and route conflicts.
3.  **UI/UX Refinement**: Adding premium icon pickers and improving screen transitions.

## Architecture Highlights
- **Framework**: Flutter (Dart)
- **State Management**: Riverpod
- **Database**: Drift (SQLite) with schema version 5.
- **Routing**: go_router
- **Animations**: flutter_animate

## Recent Activity (Last Session)
- Corrected a critical navigation crash caused by route path shadowing (`/journal/entry/new` vs `/journal/entry/:id`).
- Implemented a "leading" back button on `HabitDetailScreen` with a fallback mechanism to Home if the navigation stack is empty.
- Updated `HabitCard` to use `context.push` ensuring sub-screens remain in the history.
- Planned a "Timer Habit" feature that will include:
    - Custom duration selection.
    - Automatic Do Not Disturb (DND) mode on Android via native MethodChannels.
    - Auto-completion of habits upon timer completion.

## Next Objectives
1.  **Timer Habit Implementation**:
    - Update schema to version 6.
    - Implement Kotlin side and Flutter service for DND.
    - Build the `HabitTimerScreen`.
2.  **General Refinement**: Continue addressing lint issues and cleaning up legacy code.

## Identity & Standards
- **Standard**: Follows "Antigravity" architecture (flat logic, guard clauses, strategy patterns, maximum 2 levels of indentation).
- **Communication**: Senior-level technical collaboration.
