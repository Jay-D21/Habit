import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_theme.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/gamification_providers.dart';

/// Greeting header with time-based greeting, XP badge, and settings access
class GreetingHeader extends ConsumerWidget {
  const GreetingHeader({super.key});

  static const _greetings = {
    'morning': ('Good Morning', '☀️'),
    'afternoon': ('Good Afternoon', '🌤️'),
    'evening': ('Good Evening', '🌙'),
  };

  static const _quotes = [
    '"Small steps lead to big changes."',
    '"Consistency is the key to success."',
    '"Every day is a new opportunity."',
    '"Progress, not perfection."',
    '"You are what you repeatedly do."',
    '"One habit at a time."',
    '"Make today count."',
    '"Start where you are."',
  ];

  (String, String) _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return _greetings['morning']!;
    if (hour < 17) return _greetings['afternoon']!;
    return _greetings['evening']!;
  }

  String _getQuote() => _quotes[DateTime.now().day % _quotes.length];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final today = DateFormat('EEEE, MMMM d').format(DateTime.now());
    final userProgressAsync = ref.watch(userProgressProvider);
    final (greeting, emoji) = _getGreeting();

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppTheme.spacingLg,
        AppTheme.spacingMd,
        AppTheme.spacingLg,
        AppTheme.spacingSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: Date + Settings gear
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                today,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  letterSpacing: 0.5,
                ),
              ),
              // Settings gear icon
              GestureDetector(
                onTap: () => context.go('/settings'),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest
                        .withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                  ),
                  child: Icon(
                    Icons.settings_outlined,
                    size: 20,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingXs),

          // Greeting
          Text(
            '$emoji $greeting!',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppTheme.spacingXs),

          // XP Badge row
          userProgressAsync.when(
            data: (progress) {
              if (progress == null) return const SizedBox.shrink();
              return Row(
                children: [
                  _XpBadge(level: progress.level),
                  const SizedBox(width: AppTheme.spacingSm),
                  Text(
                    '${progress.xp} XP',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          const SizedBox(height: AppTheme.spacingXs),

          // Quote
          Text(
            _getQuote(),
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.primary.withValues(alpha: 0.8),
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

class _XpBadge extends StatelessWidget {
  final int level;
  const _XpBadge({required this.level});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.accent.withValues(alpha: 0.15),
            AppColors.accent.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
        border: Border.all(
          color: AppColors.accent.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.insights_rounded, size: 14, color: AppColors.accent),
          const SizedBox(width: 3),
          Text(
            'Lvl $level',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.accent,
                  fontSize: 11,
                ),
          ),
        ],
      ),
    );
  }
}
