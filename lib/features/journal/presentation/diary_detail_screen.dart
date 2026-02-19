import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_theme.dart';
import '../../../../core/providers/journal_providers.dart';
import '../data/models/diary.dart';

/// Screen for a specific diary's entries
class DiaryDetailScreen extends ConsumerStatefulWidget {
  final int diaryId;
  final Diary? diary; // Optional, can be fetched by ID if null

  const DiaryDetailScreen({
    super.key,
    required this.diaryId,
    this.diary,
  });

  @override
  ConsumerState<DiaryDetailScreen> createState() => _DiaryDetailScreenState();
}

class _DiaryDetailScreenState extends ConsumerState<DiaryDetailScreen> {
  int _selectedView = 0; // 0: Calendar, 1: List
  DateTime _selectedMonth = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // If diary not passed, we could fetch it, but for now assuming it's passed or we handle null gracefully in title
    final diaryName = widget.diary?.name ?? 'Diary';
    final diaryColor = widget.diary?.colorObj ?? AppColors.primary;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(AppTheme.spacingLg),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.surfaceDark
                          : AppColors.backgroundLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_rounded),
                      onPressed: () => context.pop(),
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacingMd),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          diaryName,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: diaryColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          widget.diary?.description ?? 'Your memories',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.6),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  // View Toggle
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.surfaceDark
                          : AppColors.backgroundLight,
                      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _ViewToggleButton(
                          icon: Icons.calendar_month_rounded,
                          isSelected: _selectedView == 0,
                          onTap: () => setState(() => _selectedView = 0),
                          activeColor: diaryColor,
                        ),
                        _ViewToggleButton(
                          icon: Icons.list_rounded,
                          isSelected: _selectedView == 1,
                          onTap: () => setState(() => _selectedView = 1),
                          activeColor: diaryColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: _selectedView == 0
                  ? _DiaryCalendarView(
                      diaryId: widget.diaryId,
                      selectedMonth: _selectedMonth,
                      onMonthChanged: (d) => setState(() => _selectedMonth = d),
                      accentColor: diaryColor,
                    )
                  : _DiaryListView(
                      diaryId: widget.diaryId,
                      accentColor: diaryColor,
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showNewEntryOptions(context),
        backgroundColor: diaryColor,
        icon: const Icon(Icons.edit_rounded, color: Colors.white),
        label: const Text('Write', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  void _showNewEntryOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Add to ${widget.diary?.name ?? "Diary"}',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 24),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: (widget.diary?.colorObj ?? AppColors.primary)
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.today_rounded,
                      color: widget.diary?.colorObj ?? AppColors.primary),
                ),
                title: const Text('Entry for Today'),
                onTap: () {
                  Navigator.pop(context);
                  // Push to new entry screen with today's date
                  context.push('/journal/new', extra: {
                    'diaryId': widget.diaryId,
                    'date': DateTime.now(),
                  });
                },
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.date_range_rounded,
                      color: AppColors.secondary),
                ),
                title: const Text('Pick a Date'),
                onTap: () {
                  Navigator.pop(context);
                  _pickDateAndCreate(context);
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickDateAndCreate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (date != null && context.mounted) {
      context.push('/journal/new', extra: {
        'diaryId': widget.diaryId,
        'date': date,
      });
    }
  }
}

class _ViewToggleButton extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final Color activeColor;

  const _ViewToggleButton({
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
            vertical: AppTheme.spacingSm, horizontal: AppTheme.spacingMd),
        decoration: BoxDecoration(
          color: isSelected ? activeColor : Colors.transparent,
          borderRadius: BorderRadius.circular(AppTheme.radiusSm),
        ),
        child: Icon(
          icon,
          size: 20,
          color: isSelected
              ? Colors.white
              : theme.colorScheme.onSurface.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}

class _DiaryCalendarView extends ConsumerWidget {
  final int diaryId;
  final DateTime selectedMonth;
  final ValueChanged<DateTime> onMonthChanged;
  final Color accentColor;

  const _DiaryCalendarView({
    required this.diaryId,
    required this.selectedMonth,
    required this.onMonthChanged,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final firstDayOfMonth =
        DateTime(selectedMonth.year, selectedMonth.month, 1);
    final lastDayOfMonth =
        DateTime(selectedMonth.year, selectedMonth.month + 1, 0);
    final daysInMonth = lastDayOfMonth.day;
    final startWeekday = firstDayOfMonth.weekday; // 1 = Monday

    final entriesAsync = ref.watch(entriesForDiaryProvider(diaryId));

    return entriesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (entries) {
          // Map entries by date for quick lookup
          final Map<int, bool> dayHasEntry = {};
          for (var e in entries) {
            if (e.date.year == selectedMonth.year &&
                e.date.month == selectedMonth.month) {
              dayHasEntry[e.date.day] = true;
            }
          }

          return Column(
            children: [
              // Month navigation
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppTheme.spacingLg),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => onMonthChanged(
                        DateTime(selectedMonth.year, selectedMonth.month - 1),
                      ),
                      icon: const Icon(Icons.chevron_left_rounded),
                    ),
                    Text(
                      DateFormat('MMMM yyyy').format(selectedMonth),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      onPressed: () => onMonthChanged(
                        DateTime(selectedMonth.year, selectedMonth.month + 1),
                      ),
                      icon: const Icon(Icons.chevron_right_rounded),
                    ),
                  ],
                ),
              ),

              // Weekday headers
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingLg,
                  vertical: AppTheme.spacingSm,
                ),
                child: Row(
                  children: ['S', 'M', 'T', 'W', 'T', 'F', 'S']
                      .map((day) => Expanded(
                            child: Center(
                              child: Text(
                                day,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withValues(alpha: 0.5),
                                ),
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),

              // Calendar grid
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingLg),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                    ),
                    itemCount: 42, // 6 weeks
                    itemBuilder: (context, index) {
                      final adjustedStart =
                          startWeekday == 7 ? 0 : startWeekday;
                      final day = index - adjustedStart + 1;

                      if (day < 1 || day > daysInMonth) {
                        return const SizedBox.shrink();
                      }

                      final hasEntry = dayHasEntry[day] ?? false;
                      final isToday = _isToday(day, selectedMonth);

                      return GestureDetector(
                        onTap: () {
                          // Open entry for this date if exists, or create new
                          context.push('/journal/new', extra: {
                            'diaryId': diaryId,
                            'date': DateTime(
                                selectedMonth.year, selectedMonth.month, day),
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: hasEntry
                                ? accentColor.withValues(
                                    alpha: isDark ? 0.3 : 0.15)
                                : (isDark
                                    ? AppColors.surfaceDark
                                    : AppColors.backgroundLight),
                            borderRadius:
                                BorderRadius.circular(AppTheme.radiusSm),
                            border: isToday
                                ? Border.all(color: accentColor, width: 2)
                                : null,
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Text(
                                '$day',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: isToday
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: isToday ? accentColor : null,
                                ),
                              ),
                              if (hasEntry)
                                Positioned(
                                  bottom: 4,
                                  child: Container(
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: accentColor,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ).animate().fadeIn();
        });
  }

  bool _isToday(int day, DateTime month) {
    final now = DateTime.now();
    return now.year == month.year && now.month == month.month && now.day == day;
  }
}

class _DiaryListView extends ConsumerWidget {
  final int diaryId;
  final Color accentColor;

  const _DiaryListView({required this.diaryId, required this.accentColor});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final entriesAsync = ref.watch(entriesForDiaryProvider(diaryId));

    return entriesAsync.when(
      data: (entries) {
        if (entries.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.menu_book_rounded,
                    size: 64,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.2)),
                const SizedBox(height: 16),
                Text(
                  'No entries yet',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                  ),
                ),
              ],
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(AppTheme.spacingLg),
          itemCount: entries.length,
          itemBuilder: (context, index) {
            final entry = entries[index];
            return InkWell(
              onTap: () {
                // Open entry details (or edit)
                // For now, re-using new entry screen but passing existing entry?
                // Or I need a proper EntryDetailScreen?
                // Usually "New Entry" screen can function as "Edit" if passed an ID.
                // But wait, the route `/journal/new` was mapped to `JournalEntryScreen`.
                // I should use that.
                context.push('/journal/entry/${entry.id}', extra: entry);
              },
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              child: Container(
                margin: const EdgeInsets.only(bottom: AppTheme.spacingMd),
                padding: const EdgeInsets.all(AppTheme.spacingMd),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardDark : AppColors.cardLight,
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  border: Border.all(
                    color:
                        isDark ? AppColors.borderDark : AppColors.borderLight,
                  ),
                ),
                child: Row(
                  children: [
                    // Icon
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: (entry.iconColor != null
                                ? Color(entry.iconColor!)
                                : accentColor)
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: entry.iconCodePoint != null
                            ? Icon(
                                IconData(entry.iconCodePoint!,
                                    fontFamily: 'MaterialIcons'),
                                color: entry.iconColor != null
                                    ? Color(entry.iconColor!)
                                    : accentColor,
                                size: 24)
                            : Text(entry.moodEmoji,
                                style: const TextStyle(fontSize: 24)),
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacingMd),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                DateFormat('MMM d, yyyy').format(entry.date),
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: accentColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (entry.hasVoiceNote)
                                Icon(Icons.mic_rounded,
                                    size: 14,
                                    color: theme.colorScheme.onSurface
                                        .withValues(alpha: 0.4)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            entry.title.isNotEmpty ? entry.title : 'No Title',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            entry.content,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.6),
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
                .fadeIn(delay: Duration(milliseconds: 50 * index))
                .slideX(begin: 0.1, end: 0);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: Text('Error loading journal')),
    );
  }
}
