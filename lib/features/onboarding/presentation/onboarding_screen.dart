import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_theme.dart';

// ──────────── Tutorial Page Config ────────────
class _TutorialPage {
  final IconData icon;
  final Color color;
  final String title;
  final String description;
  final List<_FeatureItem> features;

  const _TutorialPage({
    required this.icon,
    required this.color,
    required this.title,
    required this.description,
    this.features = const [],
  });
}

class _FeatureItem {
  final IconData icon;
  final String text;
  const _FeatureItem({required this.icon, required this.text});
}

const _pages = [
  _TutorialPage(
    icon: Icons.auto_awesome_rounded,
    color: AppColors.primary,
    title: 'Welcome to Loop Habit',
    description:
        'Your personal companion for building better habits, staying focused, and reflecting on your journey.',
  ),
  _TutorialPage(
    icon: Icons.check_circle_rounded,
    color: AppColors.success,
    title: 'Track Your Habits',
    description:
        'Create habits, check them off daily, and build powerful streaks.',
    features: [
      _FeatureItem(
          icon: Icons.add_circle_outline, text: 'Create custom habits'),
      _FeatureItem(
          icon: Icons.local_fire_department, text: 'Build daily streaks'),
      _FeatureItem(
          icon: Icons.star_outline, text: 'Set priorities (Low/Medium/High)'),
    ],
  ),
  _TutorialPage(
    icon: Icons.timer_rounded,
    color: AppColors.primary,
    title: 'Focus Mode',
    description:
        'Stay productive with a Pomodoro timer — focus, break, repeat.',
    features: [
      _FeatureItem(
          icon: Icons.psychology, text: 'Customizable focus durations'),
      _FeatureItem(icon: Icons.coffee, text: 'Auto short & long breaks'),
      _FeatureItem(icon: Icons.tune, text: 'Tap to set exact minutes'),
    ],
  ),
  _TutorialPage(
    icon: Icons.book_rounded,
    color: AppColors.tertiary,
    title: 'Daily Journal',
    description: 'Capture thoughts, track your mood, and record voice notes.',
    features: [
      _FeatureItem(icon: Icons.mood, text: 'Mood tracking with emojis'),
      _FeatureItem(icon: Icons.mic, text: 'Voice note recording'),
      _FeatureItem(icon: Icons.calendar_month, text: 'Calendar & list views'),
    ],
  ),
  _TutorialPage(
    icon: Icons.emoji_events_rounded,
    color: AppColors.accent,
    title: 'Earn XP & Badges',
    description:
        'Stay motivated with a gamification system that rewards consistency.',
    features: [
      _FeatureItem(icon: Icons.insights, text: 'Earn XP for completions'),
      _FeatureItem(
          icon: Icons.workspace_premium, text: 'Unlock achievement badges'),
      _FeatureItem(
          icon: Icons.bar_chart, text: 'Track progress with analytics'),
    ],
  ),
  _TutorialPage(
    icon: Icons.rocket_launch_rounded,
    color: AppColors.success,
    title: "You're All Set!",
    description:
        "Start building habits that stick. Tap below to begin your journey.",
  ),
];

// ──────────── Onboarding Screen ────────────
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      return;
    }
    _finish();
  }

  void _finish() {
    // If we can pop (came from Settings), pop back
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
      return;
    }
    // Otherwise (first launch), go to home
    context.go('/home');
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLastPage = _currentPage == _pages.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top: Skip
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingLg,
                vertical: AppTheme.spacingSm,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _finish,
                    child: Text(
                      'Skip',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.4),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (page) => setState(() => _currentPage = page),
                itemCount: _pages.length,
                itemBuilder: (context, index) =>
                    _TutorialPageWidget(page: _pages[index]),
              ),
            ),

            // Progress bar
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingXxl,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: LinearProgressIndicator(
                  value: (_currentPage + 1) / _pages.length,
                  minHeight: 3,
                  backgroundColor:
                      theme.colorScheme.onSurface.withValues(alpha: 0.08),
                  valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                ),
              ),
            ),

            const SizedBox(height: AppTheme.spacingLg),

            // Bottom: Page counter + Next button
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppTheme.spacingXl,
                0,
                AppTheme.spacingXl,
                AppTheme.spacingXl,
              ),
              child: Row(
                children: [
                  // Page counter
                  Text(
                    '${_currentPage + 1}/${_pages.length}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                    ),
                  ),
                  const Spacer(),
                  // Next / Get Started
                  FilledButton(
                    onPressed: _nextPage,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(isLastPage ? 'Get Started' : 'Next'),
                        if (!isLastPage) ...[
                          const SizedBox(width: 4),
                          const Icon(Icons.arrow_forward, size: 16),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────── Tutorial Page Widget ────────────
class _TutorialPageWidget extends StatelessWidget {
  final _TutorialPage page;
  const _TutorialPageWidget({required this.page});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingXl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon circle
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  page.color.withValues(alpha: 0.2),
                  page.color.withValues(alpha: 0.05),
                ],
              ),
              border: Border.all(
                color: page.color.withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
            child: Icon(page.icon, size: 40, color: page.color),
          ),

          const SizedBox(height: AppTheme.spacingXl),

          // Title
          Text(
            page.title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppTheme.spacingSm),

          // Description
          Text(
            page.description,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),

          // Feature list (if any)
          if (page.features.isNotEmpty) ...[
            const SizedBox(height: AppTheme.spacingXl),
            ...page.features.map((f) => Padding(
                  padding: const EdgeInsets.only(bottom: AppTheme.spacingSm),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingMd,
                      vertical: AppTheme.spacingSm,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? page.color.withValues(alpha: 0.08)
                          : page.color.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                      border: Border.all(
                        color: page.color.withValues(alpha: 0.1),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(f.icon,
                            size: 18, color: page.color.withValues(alpha: 0.7)),
                        const SizedBox(width: AppTheme.spacingSm),
                        Expanded(
                          child: Text(
                            f.text,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.7),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
          ],
        ],
      ),
    );
  }
}
