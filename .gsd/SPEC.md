# Habit Tracker V2.0 Specification

> **Status:** FINALIZED
> **Version:** 2.0

## Goal
Make Habit Tracker **outstanding in the market** by adding 5 differentiator features: Priority, Gamification, Notifications, Voice Journal, and Focus Mode.

## Core Features

### 1. Priority System (Completed)
- **Problem**: Most apps treat all habits equally.
- **Solution**: 5-level priority (Minimal to Critical).
- **Mechanics**: High priority = Higher XP multiplier (up to 2.5x).
- **UI**: Stars on cards, "Top Priority" section.

### 2. Gamification
- **Problem**: Keeping habits is boring.
- **Solution**: RPG-like progression.
- **Mechanics**: 
    - XP for completions (base * multiplier).
    - Levels (Beginner -> Legend).
    - Badges (Unlockables for streaks, specific habits).

### 3. Notification Scheduling
- **Problem**: Users forget habits.
- **Solution**: Reliable local notifications.
- **Mechanics**: Custom time per habit, daily repeats.

### 4. Voice Journal
- **Problem**: Typing reflections is friction.
- **Solution**: Audio notes.
- **Mechanics**: Record/Play AAC files linked to completion.

### 5. Focus Mode
- **Problem**: Habits require focused time.
- **Solution**: In-app Pomodoro timer.
- **Mechanics**: 25/5 intervals, link to specific habit, bonus XP.

## Technical Constraints
- **Stack**: Flutter + Riverpod + Drift (SQLite).
- **Offline First**: All data local.
- **Performance**: Instant load, smooth animations.
