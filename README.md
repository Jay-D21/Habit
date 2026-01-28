# Loop - Premium Habit Tracker App 🚀

A beautiful, gamified habit tracking application built with Flutter, designed to help users build and maintain positive habits through detailed analytics, journaling, and a rewarding progress system.

## 📱 Features

### Core Habit Tracking
- **Daily Dashboard**: View and check off habits for the day.
- **Customizable Habits**: Set frequency (Daily/Weekly), reminders, and colors.
- **Smart Scheduling**: Flexible habit schedules to fit any lifestyle.

### 🎮 Gamification & Engagement
- **Virtual Pet Companion**: Your pet evolves as you complete habits and maintain streaks.
- **Mood Tracking**: Track your daily mood alongside your habits.
- **Streak System**: maintain streaks to earn rewards and unlock achievements.

### 📊 Advanced Analytics
- **Interactive Charts**: Daily/Monthly completion rates.
- **Heatmaps**: Visual representation of your consistency over time.
- **Top Performing Habits**: Optimized insights into your best habits.
- **Journaling**: Integrated daily journal to reflect on your progress.

### 💰 Monetization (AdMob)
- **Non-Intrusive Ads**: Strategically placed banner ads (Home, Analytics, Journal, Habits).
- **Smart Interstitials**: Frequency-capped interstitial ads (every 3rd app open / 3rd habit completion).
- **Robust Error Handling**: Auto-retry logic with exponential backoff for network resilience.

---

## 🛠 Tech Stack

- **Framework**: [Flutter](https://flutter.dev/) (Dart)
- **State Management**: [Riverpod 2.0](https://riverpod.dev/) (Code generation + annotation)
- **Local Database**: [Drift](https://drift.simonbinder.eu/) (SQLite abstraction)
- **Authentication**: [AWS Amplify](https://docs.amplify.aws/) (Cognito)
- **Navigation**: [GoRouter](https://pub.dev/packages/go_router)
- **Ads**: [Google Mobile Ads](https://pub.dev/packages/google_mobile_ads)
- **UI/Animations**: `flutter_animate`, Custom Painters, Glassmorphism design.

---

## 🚧 Challenges & Solutions

During development, we encountered and solved several complex technical challenges:

### 1. AdMob Reliability & User Experience
*   **Challenge**: Ads would sometimes fail to load due to network issues, leaving blank spaces or confusing UI. Interstitial ads would annoy users if shown too often.
*   **Solution**: 
    *   Implemented **Exponential Backoff Retry Logic**: If an ad fails, we retry after 2s, 4s, 8s (up to 3 times).
    *   **Custom Fallback UI**: Instead of blank space, we show a "Loading..." spinner or a "Retry" button for manual control.
    *   **Frequency Capping**: Logic added to `AdFrequencyManager` to strictly limit interstitials to every 3rd app open or habit completion.

### 2. Analytics Performance
*   **Challenge**: The "Top Performing Habits" section was loading very slowly (~500ms+ delay).
*   **Constraint**: We were running `N` separate database queries (one for each habit) inside a loop to count completions.
*   **Solution**: Optimized to **O(1)** query. We now fetch *all* completions for the month in a single bulk query and group them in-memory using a Hash Map. Loading time dropped to <50ms (10x improvement).

### 3. UI/Layout Scaling
*   **Challenge**: The "Today's Habits" list on the Home Screen was cut off and not scrollable. Analytics charts were cramped side-by-side on smaller screens.
*   **Solution**: 
    *   Replaced rigid `Column` layouts with `ConstrainedBox` + `SingleChildScrollView` to enable scrolling without infinite height errors.
    *   Refactored Analytics layout from `Row` (side-by-side) to `Column` (stacked) for full-width visibility on mobile devices.

### 4. Build & Release Configuration
*   **Challenge**: Generating an optimized APK size while ensuring compatibility with all Android devices.
*   **Solution**: Configured `split-per-abi` in `flutter build` to generate separate APKs for `arm64-v8a` (modern) and `armeabi-v7a` (older) architectures, reducing the download size by ~40% (from ~60MB to ~35MB).

### 5. ProGuard & Obfuscation
*   **Challenge**: Release builds were crashing because ProGuard was stripping out essential names required by Drift (database) and Reflection.
*   **Solution**: Created a custom `proguard-rules.pro` to explicitly keep class names for Drift tables and Flutter framework classes.

---

## 📦 How to Build

### Prerequisites
- Flutter SDK (3.x)
- Java 17 (for Android build)
- Firebase & AWS configuration files

### Commands
```bash
# Install dependencies
flutter pub get

# Generate code (Riverpod/Drift)
dart run build_runner build -d

# Run in Debug mode
flutter run

# Build Release APK (Split per architecture)
flutter build apk --release --split-per-abi
```

## 📂 Project Structure

```
lib/
├── app/                 # App configuration (Theme, Router)
├── core/                # Core services (Database, Ads, Auth)
├── features/            # Feature-based folders
│   ├── habits/          # Habit CRUD, Lists
│   ├── home/            # Dashboard widgets
│   ├── analytics/       # Charts & Stats
│   ├── journal/         # Daily entries
│   └── settings/        # App preference
└── shared/              # Reusable widgets
```
