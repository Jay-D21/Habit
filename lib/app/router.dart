import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/home/presentation/home_screen.dart';

import '../features/habits/presentation/habit_detail_screen.dart';
import '../features/journal/presentation/journal_screen.dart';
import '../features/journal/presentation/journal_entry_screen.dart';
import '../features/journal/presentation/template_picker_screen.dart';
import '../features/journal/presentation/journal_template_detail_screen.dart';
import '../features/journal/data/models/journal_template.dart';
import '../features/analytics/presentation/analytics_screen.dart';
import '../features/settings/presentation/settings_screen.dart';
import '../features/onboarding/presentation/onboarding_screen.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/signup_screen.dart';
import '../features/auth/presentation/confirm_signup_screen.dart';
import '../features/auth/presentation/verify_otp_screen.dart';

import '../features/focus/presentation/focus_mode_screen.dart';
import '../shared/widgets/main_scaffold.dart';

/// App router configuration using GoRouter
class AppRouter {
  AppRouter._();

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/home',
    routes: [
      // Onboarding (outside shell)
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),

      // Auth Routes
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/confirm-signup',
        builder: (context, state) {
          final username = state.extra as String;
          return ConfirmSignupScreen(username: username);
        },
      ),
      GoRoute(
        path: '/verify-otp',
        builder: (context, state) {
          final phoneNumber = state.extra as String;
          return VerifyOtpScreen(phoneNumber: phoneNumber);
        },
      ),

      // Main app shell with bottom navigation
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => MainScaffold(child: child),
        routes: [
          // Home/Dashboard
          GoRoute(
            path: '/home',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomeScreen(),
            ),
          ),

          // Journal
          GoRoute(
            path: '/journal',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: JournalScreen(),
            ),
          ),

          // Analytics
          GoRoute(
            path: '/analytics',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: AnalyticsScreen(),
            ),
          ),

          // Focus Mode
          GoRoute(
            path: '/focus',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: FocusModeScreen(),
            ),
          ),

          // Settings (inside shell for bottom nav)
          GoRoute(
            path: '/settings',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: SettingsScreen(),
            ),
          ),
        ],
      ),

      // (Settings moved inside ShellRoute above)

      // Tutorial (re-viewable onboarding)
      GoRoute(
        path: '/tutorial',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const OnboardingScreen(),
      ),

      // Habit Detail (Full Screen)
      GoRoute(
        path: '/habits/:habitId',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => HabitDetailScreen(
          habitId: state.pathParameters['habitId']!,
        ),
      ),

      // Journal Entry (Full Screen)
      GoRoute(
        path: '/journal/new',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final template = state.extra as JournalTemplate?;
          return JournalEntryScreen(template: template);
        },
      ),
      GoRoute(
        path: '/journal/templates',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const TemplatePickerScreen(),
      ),
      GoRoute(
        path: '/journal/template-details',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final template = state.extra as JournalTemplate;
          return JournalTemplateDetailScreen(template: template);
        },
      ),
      GoRoute(
        path: '/journal/:entryId',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => JournalEntryScreen(
          entryId: state.pathParameters['entryId'],
        ),
      ),
    ],
  );
}
