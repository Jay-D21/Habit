# Walkthrough - Multi-Diary Architecture

## Overview
I have refactored the Journal feature to support **Multiple Diaries**, allowing users to organize their entries into separate journals (e.g., "Personal", "Work", "Gratitude"). The old mood selector has been replaced with a premium custom icon picker.

## Key Changes

### 1. Multi-Diary Support
- **Database**: Added `Diaries` table and linked `JournalEntries` to it via `diaryId`.
- **Migration**: Existing entries are automatically migrated to a default "My Journal".
- **Models**: Updated `JournalEntry` and created `Diary` model.

### 2. New Journal Screen
- **Diaries Grid**: The main journal screen now displays a grid of your diaries.
- **Create Diary**: Users can create new diaries using templates (e.g., "Daily Reflection", "Manifestation").
- **Diary Detail**: Clicking a diary opens a dedicated view for that diary's entries.

### 3. Enhanced Entry Experience
- **Custom Icons**: Replaced the fixed mood selector with a custom icon picker and color selection.
- **Date Selection**: Users can now create entries for any past date.
- **Context**: Entries are now associated with a specific diary.

### 4. Template-Based Creation
- **Templates as Blueprints**: Selecting a template now initiates the creation of a *new diary* based on that template, rather than just a single entry.
- **Customization**: Users can name their new diary during creation.

## Technical Details
- **State Management**: Updated `JournalNotifier` to handle creating diaries and filtering entries by diary ID.
- **Routing**: Added routes for `diary/:id` and updated entry routes.
- **Database**: Implemented schema version 5 with migration logic.

## Key Fixes
- **Navigation**: Added a back button to `HabitDetailScreen` and updated `HabitCard` to use `context.push` instead of `context.go` to preserve navigation stack. Added robust fallback to navigate Home if stack is empty.
- **Router Conflict**: Fixed a navigation issue where creating a new entry from a specific diary was crashing due to a route path conflict (`/journal/entry/new` vs `/journal/entry/:id`). Corrected the path to `/journal/new`.

## Verification
- **Code**: `build_runner` executed to regenerate database code.
- **Analysis**: `flutter analyze` passed with 0 issues.
- **Manual Check**: Ready for user verification on device.
