import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../core/services/quote_service.dart';

class MotivationalQuoteCard extends ConsumerWidget {
  const MotivationalQuoteCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quote = ref.watch(dailyQuoteProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLg),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppTheme.spacingLg),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    AppColors.primary.withValues(alpha: 0.15),
                    AppColors.primaryDark.withValues(alpha: 0.08),
                  ]
                : [
                    AppColors.primaryContainer.withValues(alpha: 0.4),
                    AppColors.primary.withValues(alpha: 0.05),
                  ],
          ),
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: isDark ? 0.2 : 0.1),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.format_quote_rounded,
              color: AppColors.primary.withValues(alpha: 0.6),
              size: 24,
            ),
            const SizedBox(width: AppTheme.spacingSm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    quote.text,
                    style: GoogleFonts.merriweather(
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                      height: 1.4,
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.85)
                          : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingXs),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "— ${quote.author}",
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AppColors.primary.withValues(alpha: 0.7),
                        fontWeight: FontWeight.w600,
                      ),
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
