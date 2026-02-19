import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_theme.dart';
import '../../../../core/providers/journal_providers.dart';

/// Journal screen with entries list
class JournalScreen extends ConsumerStatefulWidget {
  const JournalScreen({super.key});

  @override
  ConsumerState<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends ConsumerState<JournalScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(AppTheme.spacingLg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'My Journal',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      FilledButton.icon(
                        onPressed: () => context.push('/journal/templates'),
                        icon: const Icon(Icons.add_rounded, size: 20),
                        label: const Text('New Diary'),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppTheme.spacingMd,
                            vertical: AppTheme.spacingSm,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spacingXs),
                  Text(
                    'Reflect on your journey, one day at a time',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 300.ms),

            // Stats cards
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppTheme.spacingLg),
              child: Consumer(
                builder: (context, ref, _) {
                  final totalCount = ref.watch(journalCountProvider);
                  final streakAsync = ref.watch(journalStreakProvider);

                  return Row(
                    children: [
                      _StatCard(
                        icon: Icons.article_rounded,
                        value: '$totalCount',
                        label: 'Total Entries',
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: AppTheme.spacingMd),
                      _StatCard(
                        icon: Icons.local_fire_department_rounded,
                        value: '${streakAsync.value ?? 0}',
                        label: 'Streak',
                        color: AppColors.accent,
                      ),
                    ],
                  );
                },
              ),
            ).animate().fadeIn(duration: 300.ms, delay: 100.ms),

            const SizedBox(height: AppTheme.spacingLg),

            // Diaries Grid
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppTheme.spacingLg),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'YOUR DIARIES',
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => context.push('/journal/templates'),
                    icon:
                        const Icon(Icons.add_circle_outline_rounded, size: 16),
                    label: const Text('Add New'),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppTheme.spacingSm),

            Expanded(
              child: Consumer(
                builder: (context, ref, _) {
                  final diariesAsync = ref.watch(diariesProvider);

                  return diariesAsync.when(
                    data: (diaries) {
                      if (diaries.isEmpty) {
                        // Fallback if no diaries (shouldn't happen with migration)
                        return Center(
                            child: TextButton(
                                onPressed: () =>
                                    context.push('/journal/templates'),
                                child: const Text('Create your first diary')));
                      }
                      return GridView.builder(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppTheme.spacingLg, vertical: 8),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: AppTheme.spacingMd,
                          crossAxisSpacing: AppTheme.spacingMd,
                          childAspectRatio: 0.9,
                        ),
                        itemCount: diaries.length,
                        itemBuilder: (context, index) {
                          final diary = diaries[index];
                          return InkWell(
                            onTap: () {
                              // Navigate to Diary Detail Screen
                              // We'll implementation this route next
                              context.push('/journal/diary/${diary.id}',
                                  extra: diary);
                            },
                            borderRadius:
                                BorderRadius.circular(AppTheme.radiusLg),
                            child: Container(
                              decoration: BoxDecoration(
                                color: diary.colorObj.withValues(alpha: 0.15),
                                borderRadius:
                                    BorderRadius.circular(AppTheme.radiusLg),
                                border: Border.all(
                                  color: diary.colorObj.withValues(alpha: 0.3),
                                  width: 1.5,
                                ),
                              ),
                              child: Stack(
                                children: [
                                  // Icon watermark
                                  Positioned(
                                    right: -10,
                                    bottom: -10,
                                    child: Icon(
                                      diary.icon,
                                      size: 80,
                                      color:
                                          diary.colorObj.withValues(alpha: 0.1),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(
                                        AppTheme.spacingMd),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.white
                                                .withValues(alpha: 0.5),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(diary.icon,
                                              color: diary.colorObj),
                                        ),
                                        const Spacer(),
                                        Text(
                                          diary.name,
                                          style: theme.textTheme.titleMedium
                                              ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: diary.colorObj.withValues(
                                                alpha: 0.9), // Darker shade
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          diary.description ??
                                              'Personal entries',
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(
                                            color: theme.colorScheme.onSurface
                                                .withValues(alpha: 0.6),
                                            fontSize: 11,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                              .animate()
                              .fadeIn(delay: (50 * index).ms)
                              .slideY(begin: 0.1, end: 0);
                        },
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (e, st) => Center(child: Text('Error: $e')),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacingMd),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusSm),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: AppTheme.spacingMd),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
