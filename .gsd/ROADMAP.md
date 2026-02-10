---
milestone: Habit Tracker V2.0
version: 2.0.0
updated: 2026-02-10
---

# Roadmap

> **Current Phase:** 2 - Gamification
> **Status:** 🔄 In Progress

## Must-Haves (from SPEC)

- [x] Priority System (5-star scale, UI integration)
- [ ] Gamification (XP, Levels, Badges)
- [ ] Notification Scheduling (Local notifications)
- [ ] Voice Journal (Record/Play audio)
- [ ] Focus Mode (Pomodoro timer)

---

## Phases

### Phase 1: Priority System ⭐
**Status:** ✅ Complete
**Objective:** Implement core priority mechanics to differentiate habits.
**Requirements:** 5-level priority, XP multipliers, UI integration.

**Plans:**
- [x] Add priority column to database
- [x] Create priority enum and logic
- [x] UI: Priority Selector Widget
- [x] UI: Habit Card updates (stars)
- [x] UI: Top Priority Today section
- [x] UI: Smart Sorting
- [ ] Database migration (pending verify)

---

### Phase 2: Gamification (XP/Levels/Badges)
**Status:** 🔄 In Progress
**Objective:** Add retention mechanics through leveling and achievements.
**Depends on:** Phase 1 (Priority Multipliers)

**Plans:**
- [x] Database: User Progress table
- [x] Service: Gamification logic (XP calcs)
- [x] UI: Level Progress Widget (Header)
- [ ] UI: Badges Screen
- [ ] UI: Badges Screen
- [ ] Feature: Badge unlocking logic
- [ ] Feature: Priority-specific badges

---

### Phase 3: Notification Scheduling
**Status:** ✅ Complete
**Objective:** reliable local reminders for habits.

**Plans:**
- [x] Service: Notification Manager
- [x] Logic: Schedule based on habit time
- [x] UI: Permissions handling

---

### Phase 4: Voice Journal Recording
**Status:** ⬜ Not Started
**Objective:** Audio journaling capability.

**Plans:**
- [ ] Dependency: `record` package
- [ ] Service: Audio Recorder/Player
- [ ] UI: Voice Recorder Widget
- [ ] Integration: Journal Screen

---

### Phase 5: Focus Mode (Pomodoro)
**Status:** ⬜ Not Started
**Objective:** Integrated timer for focused work.

**Plans:**
- [ ] Database: Focus Settings
- [ ] Service: Timer Logic
- [ ] UI: Focus Mode Screen

---

## Progress Summary

| Phase | Status | Plans | Complete |
|-------|--------|-------|----------|
| 1 | ✅ | 7/7 | 100% |
| 2 | 🔄 | 3/6 | 50% |
| 3 | ✅ | 3/3 | 100% |
| 4 | ⬜ | 0/4 | 0% |
| 5 | ⬜ | 0/3 | 0% |
