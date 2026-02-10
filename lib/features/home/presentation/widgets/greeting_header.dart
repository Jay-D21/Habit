import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_theme.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/gamification_providers.dart';

/// Greeting header with time-based greeting and motivational quote
class GreetingHeader extends ConsumerWidget {
  const GreetingHeader({super.key});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  String _getGreetingEmoji() {
    final hour = DateTime.now().hour;
    if (hour < 12) return '☀️';
    if (hour < 17) return '🌤️';
    return '🌙';
  }

  String _getMotivationalQuote() {
    final quotes = [
      '"Small steps lead to big changes."',
      '"Consistency is the key to success."',
      '"Every day is a new opportunity."',
      '"Progress, not perfection."',
      '"You are what you repeatedly do."',
      '"One habit at a time."',
      '"Make today count."',
      '"Start where you are."',
    ];
    final index = DateTime.now().day % quotes.length;
    return quotes[index];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final today = DateFormat('EEEE, MMMM d').format(DateTime.now());
    final userProgressAsync = ref.watch(userProgressProvider);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppTheme.spacingLg,
        AppTheme.spacingLg,
        AppTheme.spacingLg,
        AppTheme.spacingMd,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date
          Text(
            today,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: AppTheme.spacingXs),

          // Greeting with emoji
          Row(
            children: [
              Text(
                '${_getGreetingEmoji()} ${_getGreeting()}!',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingXs),

          // User Level & XP
          userProgressAsync.when(
            data: (progress) {
              if (progress == null) return const SizedBox.shrink();
              return Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingSm,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                      border: Border.all(
                        color: AppColors.accent.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.insights_rounded,
                          size: 16,
                          color: AppColors.accent,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Lvl ${progress.level}',
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.accent,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacingSm),
                  Text(
                    '${progress.xp} XP',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          const SizedBox(height: AppTheme.spacingSm),

          // Motivational quote
          Text(
            _getMotivationalQuote(),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.primary,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
