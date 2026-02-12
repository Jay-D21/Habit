# Product Requirements Document (PRD)
**Project Name:** Loop - Premium Habit Tracker
**Version:** 2.0
**Status:** ACTIVE
**Last Updated:** 2026-02-10

---

## 1. Product Vision
To build the most engaging and comprehensive habit tracking application on the market by combining robust tracking mechanics with gamification, profound analytics, and seamless user experience. Loop aims to transform habit formation from a chore into a rewarding journey.

**Value Proposition:**
- **Gamified Growth:** Turn self-improvement into an RPG-like experience.
- **Deep Insights:** Go beyond checking boxes with detailed analytics and correlations.
- **Frictionless:** Offline-first, instant load times, and intuitive UI.

---

## 2. Target Audience
- **Self-Improvers:** Individuals actively seeking to build new routines (meditation, reading, fitness).
- **Procrastinators:** Users who need external motivation (gamification, streaks) to stay consistent.
- **Data Lovers:** Users who enjoy tracking metrics and visualizing progress over time.
- **ADHD/Focus-Challenged:** Users who benefit from visual cues, reminders, and "Focus Mode" timers.

---

## 3. Core Features & Functional Requirements

### 3.1 Habit Management (Core)
- **Create/Edit Habits:**
  - Name, Description, Emoji icon.
  - **Frequency:** Daily, Weekly, Specific Days (e.g., Mon, Wed, Fri).
  - **Target:** Number of times per day (e.g., Drink Water 8x).
  - **Color:** Custom hex color for visual organization.
  - **Priority:** 5-star generic priority system (Minimal -> Critical).
- **Dashboard:**
  - "Today's Habits" list sorted by Priority.
  - Quick check-off (tap) and detailed view (long press/tap).
  - "Top Priority" section for high-value tasks.

### 3.2 Gamification (The "Hook")
- **XP System:**
  - Earn XP for every habit completion.
  - **Multipliers:** Higher priority habits yield more XP (up to 2.5x).
  - **Streaks:** Bonus XP for maintaining daily/weekly streaks.
- **Leveling:**
  - Users have a "Player Level" based on total XP.
  - Visual progress bar and "Level Up" animations.
- **Badges & Achievements:**
  - Unlockable badges for milestones (e.g., "7-Day Streak", "Early Bird", "Hydration Master").
  - Badges displayed in a dedicated "Hall of Fame" or Profile section.

### 3.3 Analytics & Insights
- **Interactive Charts:**
  - Daily Completion % (Line Graph).
  - Monthly Heatmap (GitHub-style).
- **Habit Specific Stats:**
  - Current Streak, Best Streak, Total Completions.
  - Completion rate by day of week (identify weak days).

### 3.4 Journaling & Reflection
- **Daily Journal:**
  - Text entry linked to specific dates.
  - Mood Tracking (5-point scale).
- **Voice Memos (V2.0 New):**
  - Record audio reflections for quicker entry.
  - Playback capability within the journal entry.

### 3.5 Tools & Utilities
- **Focus Mode (Pomodoro):**
  - Built-in timer (25/5 min default).
  - Link timer sessions to specific habits.
  - "Do Not Disturb" enforcement (optional/permissons dependent).
- **Notifications:**
  - Local push notifications for habit reminders.
  - "Morning Briefing" and "Evening Review" summary notifications.

---

## 4. Technical Architecture

### 4.1 Tech Stack
| Component | Technology | Rationale |
|-----------|------------|-----------|
| **Framework** | Flutter (Dart) | Cross-platform, high performance, pixel-perfect UI. |
| **State Mgmt** | Riverpod 2.0 | Compile-time safety, easy testing, robust DI. |
| **Database** | Drift (SQLite) | Offline-first, reactive streams, strongly typed. |
| **Auth** | AWS Amplify (Cognito) | Secure user identity management. |
| **Backend** | Firebase (Analytics/Crashlytics) | Real-time monitoring and user behavior tracking. |
| **Monetization** | Google Mobile Ads | Banner and Interstitial integration. |

### 4.2 Data Model (Entity Relationship)
- **User:** ID, Email, XP, Level, JoinDate.
- **Habit:** ID, Name, Priority, Frequency, Color, ReminderTime.
- **HabitLog:** ID, HabitID, Timestamp, Value (Completed count).
- **Journal:** ID, Date, Text, AudioPath, Mood.
- **Achievement:** ID, Type (Streak/Count), IsUnlocked, DateUnlocked.

### 4.3 Non-Functional Requirements
- **Performance:** App launch < 2 seconds. Dashboard load < 200ms.
- **Offline Capability:** Full functionality without internet (syncs when online).
- **Privacy:** User data stored locally primarily; minimal PII sent to cloud.
- **Battery Efficiency:** Minimal background processing (only exact alarms for notifications).

---

## 5. UI/UX Guidelines
- **Design System:** Material 3 (You) adapted for "Premium" feel.
- **Typography:** Modern Sans-Serif (e.g., Poppins, Inter).
- **Color Palette:**
  - Primary: Energetic Blue/Purple gradients.
  - Success: Green (Habit completion).
  - Priority colors: Gray (1) to Red (5).
- **Interactions:**
  - Haptic feedback on completion.
  - Confetti/micro-animations for milestones.
  - Swipe gestures for quick actions (Archive/Edit).

---

## 6. Success Metrics (KPIs)
- **retention:** D1, D7, and D30 retention rates.
- **Engagement:** Average habits completed per DAU (Daily Active User).
- **Monetization:** ARPU (Average Revenue Per User) from Ad impressions.
- **Stability:** Crash-free sessions > 99.5%.

---

## 7. Roadmap (High Level)
- **Phase 1 (Done):** Core Tracking, Priority System Integration.
- **Phase 2 (Current):** Gamification Engine (XP, Levels).
- **Phase 3:** Notification Manager.
- **Phase 4:** Voice Journaling.
- **Phase 5:** Focus Mode & Polish.

*(See `.gsd/ROADMAP.md` for detailed engineering tasks)*
