import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'router.dart';
import 'theme/app_theme.dart';
import '../core/services/ad_service.dart';
import '../core/providers/theme_provider.dart';

/// Main App Widget
class HabitTrackerApp extends ConsumerStatefulWidget {
  const HabitTrackerApp({super.key});

  @override
  ConsumerState<HabitTrackerApp> createState() => _HabitTrackerAppState();
}

class _HabitTrackerAppState extends ConsumerState<HabitTrackerApp>
    with WidgetsBindingObserver {
  DateTime? _lastBackPressTime;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Trigger app-open interstitial (runs after first frame)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(adFrequencyProvider.notifier).onAppOpen();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Intercepts the Android system back button at the platform level.
  /// This runs BEFORE MaterialApp's own BackButtonDispatcher.
  @override
  Future<bool> didPopRoute() async {
    final router = AppRouter.router;

    // 1. If GoRouter has a sub-screen on the stack, pop it normally.
    if (router.canPop()) {
      router.pop();
      return true;
    }

    // 2. Determine current tab location
    final location = router.routeInformationProvider.value.uri.toString();
    final isHome = location == '/home' || location.startsWith('/home');

    // 3. If on a non-Home tab, navigate to Home first.
    if (!isHome) {
      router.go('/home');
      return true;
    }

    // 4. On Home tab: require double-tap within 2 seconds to exit.
    final now = DateTime.now();
    if (_lastBackPressTime == null ||
        now.difference(_lastBackPressTime!) > const Duration(seconds: 2)) {
      _lastBackPressTime = now;

      // Show snackbar via the root navigator's context
      final ctx = router.routerDelegate.navigatorKey.currentContext;
      if (ctx != null) {
        ScaffoldMessenger.of(ctx).showSnackBar(
          const SnackBar(
            content: Text('Tap back again to exit'),
            duration: Duration(seconds: 2),
          ),
        );
      }
      return true; // Consumed the back press
    }

    // 5. Second tap within 2s: exit the app
    SystemNavigator.pop();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);

    // Set system UI overlay style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    return MaterialApp.router(
      title: 'Loop',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: AppRouter.router,
    );
  }
}
