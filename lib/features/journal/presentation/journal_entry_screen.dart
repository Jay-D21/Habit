import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/providers/journal_notifier.dart';
import '../data/models/journal_entry.dart';

/// Journal entry creation/editing screen
class JournalEntryScreen extends ConsumerStatefulWidget {
  final String? entryId;

  const JournalEntryScreen({super.key, this.entryId});

  @override
  ConsumerState<JournalEntryScreen> createState() => _JournalEntryScreenState();
}

class _JournalEntryScreenState extends ConsumerState<JournalEntryScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  Mood _selectedMood = Mood.neutral;

  bool get _isEditing => widget.entryId != null;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _selectMood(int index) {
    setState(() => _selectedMood = Mood.values[index]);
  }

  Future<void> _saveEntry() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a title')),
      );
      return;
    }

    if (content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please write something')),
      );
      return;
    }

    await ref.read(journalNotifierProvider.notifier).createEntry(
          title: title,
          content: content,
          mood: _selectedMood,
        );

    HapticFeedback.mediumImpact();

    if (mounted) {
      context.pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Journal entry saved! 📝')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final moods = ['😊', '😐', '😔', '😤', '😌'];
    final moodLabels = ['Happy', 'Neutral', 'Sad', 'Angry', 'Calm'];
    final moodColors = [
      AppColors.moodHappy,
      AppColors.moodNeutral,
      AppColors.moodSad,
      AppColors.moodAngry,
      AppColors.moodCalm,
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Entry' : 'New Entry'),
        actions: [
          TextButton(
            onPressed: _saveEntry,
            child: const Text('Save'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            TextField(
              controller: _titleController,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                hintText: 'Entry title...',
                hintStyle: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const SizedBox(height: AppTheme.spacingLg),

            // Mood selector
            Text(
              "How are you feeling?",
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppTheme.spacingMd),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(moods.length, (index) {
                final isSelected = _selectedMood == Mood.values[index];
                return GestureDetector(
                  onTap: () => _selectMood(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(AppTheme.spacingMd),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? moodColors[index].withValues(alpha: 0.2)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                      border: Border.all(
                        color: isSelected
                            ? moodColors[index]
                            : theme.colorScheme.onSurface
                                .withValues(alpha: 0.1),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          moods[index],
                          style: TextStyle(
                            fontSize: isSelected ? 32 : 24,
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacingXs),
                        Text(
                          moodLabels[index],
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: isSelected
                                ? moodColors[index]
                                : theme.colorScheme.onSurface
                                    .withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: AppTheme.spacingXl),

            // Content
            Text(
              "What's on your mind?",
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppTheme.spacingMd),
            Container(
              constraints: const BoxConstraints(minHeight: 200),
              padding: const EdgeInsets.all(AppTheme.spacingMd),
              decoration: BoxDecoration(
                color:
                    isDark ? AppColors.surfaceDark : AppColors.backgroundLight,
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                border: Border.all(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),
              ),
              child: TextField(
                controller: _contentController,
                maxLines: null,
                style: theme.textTheme.bodyLarge,
                decoration: InputDecoration(
                  hintText: 'Write your thoughts here...',
                  hintStyle: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
            const SizedBox(height: AppTheme.spacingLg),

            // Voice note button (placeholder - would need audio recorder package)
            OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Voice recording coming soon!')),
                );
              },
              icon: const Icon(Icons.mic_rounded),
              label: const Text('Add Voice Note'),
            ),
          ],
        ),
      ),
    );
  }
}
