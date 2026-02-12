# Task List for Ralph Loop (Gamification Phase)

## Context
Phase 1 (Priority System) is complete and verified.
Phase 2 (Gamification) is partially implemented.

## Phase 2: Gamification (XP, Levels, Badges) 🎮

### Infrastructure (Existing & Verified)
- [x] Create `user_progress_table.dart` (Exists)
- [x] Create `achievements_table.dart` (Exists)
- [x] Update `database.dart` schema & migration (Version 3 verified)
- [x] Create `gamification_service.dart` (Exists, logic for XP/Levels ready)

### Missing Components (Action Items)
- [ ] **Create `gamification_providers.dart`**
  - Define `userProgressProvider` (Stream from DB).
  - Define `achievementsProvider` (Stream from DB).
  - Define `gamificationController` for handling XP awards/badge unlocking.
- [ ] **Integrate with Habit Completion**
  - Update `HabitNotifier.completeHabit` to call `GamificationController.awardXp`.
  - Use `priority` multiplier from `HabitModel` (already added).
  - Handle "Level Up" events (e.g., show dialog/overlay).

### UI Implementation
- [x] `LevelProgressCard` (Implemented & Verified)
- [x] `BadgeItem` (Implemented & Verified)
- [ ] **Update `BadgesScreen`**
  - Remove mock data (`_mockAchievements`).
  - Connect to `achievementsProvider`.
  - Add logic to display locked/unlocked state from DB.
- [ ] **Add Gamification Entry Points**
  - Add "Level/XP" indicator to Home Screen `SliverAppBar`.
  - Ensure `BadgesScreen` is accessible (e.g., from Profile or Settings).

### Data Seeding
- [ ] **Seed Default Achievements**
  - Create a method to check if achievements exist on app start.
  - Insert default badges (First Step, 7-Day Streak, etc.) if table is empty.

## Verification
- [ ] Verify XP increases when habit is completed.
- [ ] Verify Level calculation updates.
- [ ] Verify Badge unlocking (e.g., complete 1 habit -> First Step badge).
