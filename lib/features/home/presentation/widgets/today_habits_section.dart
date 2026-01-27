import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../core/providers/habit_providers.dart';
import '../../../../core/providers/habit_notifier.dart';
import '../../../habits/data/models/habit.dart';
import '../../../../core/services/ad_service.dart';

/// Today's habits section with habit list
class TodayHabitsSection extends ConsumerWidget {
  const TodayHabitsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final habitsAsync = ref.watch(habitsProvider);

    return Padding(
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Today's Habits",
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () => context.go('/habits'),
                child: const Text('See All'),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingMd),

          // Habits list
          habitsAsync.when(
            data: (habits) {
              if (habits.isEmpty) {
                return _EmptyHabitsState(
                  onAddHabit: () => _showAddHabitSheet(context, ref),
                );
              }

              return Column(
                children: [
                  ...habits.take(4).map((habit) => Padding(
                        padding:
                            const EdgeInsets.only(bottom: AppTheme.spacingSm),
                        child: _HabitItem(habit: habit),
                      )),

                  const SizedBox(height: AppTheme.spacingLg),

                  // Add habit button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _showAddHabitSheet(context, ref),
                      icon: const Icon(Icons.add_rounded),
                      label: const Text('Add New Habit'),
                    ),
                  ),
                ],
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (error, stack) => Center(
              child: Text('Error: $error'),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddHabitSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddHabitSheet(),
    );
  }
}

class _EmptyHabitsState extends StatelessWidget {
  final VoidCallback onAddHabit;

  const _EmptyHabitsState({required this.onAddHabit});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingXl),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        children: [
          const Text('🎯', style: TextStyle(fontSize: 48)),
          const SizedBox(height: AppTheme.spacingMd),
          Text(
            'No habits yet',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppTheme.spacingXs),
          Text(
            'Start building your first habit today!',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.spacingLg),
          ElevatedButton.icon(
            onPressed: onAddHabit,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Create First Habit'),
          ),
        ],
      ),
    );
  }
}

class _HabitItem extends ConsumerStatefulWidget {
  final Habit habit;

  const _HabitItem({required this.habit});

  @override
  ConsumerState<_HabitItem> createState() => _HabitItemState();
}

class _HabitItemState extends ConsumerState<_HabitItem> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final isCompleted =
        ref.watch(isHabitCompletedTodayProvider(widget.habit.id!));
    final completionCount =
        ref.watch(habitCompletionCountTodayProvider(widget.habit.id!));
    final hasProgress = widget.habit.targetCount > 1;

    // Parse habit color
    Color habitColor;
    try {
      habitColor = Color(int.parse(widget.habit.colorHex, radix: 16));
    } catch (_) {
      habitColor = AppColors.primary;
    }

    return GestureDetector(
      onTap: () {
        context.go('/habits/${widget.habit.id!}');
      },
      onLongPressStart: (_) {
        setState(() => _isPressed = true);
        HapticFeedback.mediumImpact();
      },
      onLongPressEnd: (_) async {
        setState(() => _isPressed = false);
        HapticFeedback.heavyImpact();
        await ref
            .read(habitNotifierProvider.notifier)
            .toggleHabit(widget.habit.id!);
        // Track for ad frequency (show after 2 completions)
        ref.read(adFrequencyProvider.notifier).onHabitCompleted(ref);
      },
      onLongPressCancel: () {
        setState(() => _isPressed = false);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        transform: _isPressed
            ? Matrix4.diagonal3Values(0.98, 0.98, 1.0)
            : Matrix4.identity(),
        padding: const EdgeInsets.all(AppTheme.spacingLg),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.transparent,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Emoji Container
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: habitColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  widget.habit.emoji,
                  style: const TextStyle(fontSize: 26),
                ),
              ),
            ),
            const SizedBox(width: AppTheme.spacingMd),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.habit.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      decoration: isCompleted && !hasProgress
                          ? TextDecoration.lineThrough
                          : null,
                      color: isCompleted && !hasProgress
                          ? theme.colorScheme.onSurface.withValues(alpha: 0.5)
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (hasProgress) ...[
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: (widget.habit.targetCount > 0)
                                  ? (completionCount / widget.habit.targetCount)
                                      .clamp(0.0, 1.0)
                                  : 0.0,
                              backgroundColor: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.08),
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(habitColor),
                              minHeight: 6,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '$completionCount/${widget.habit.targetCount}',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.6),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    Text(
                      widget.habit.category.name[0].toUpperCase() +
                          widget.habit.category.name.substring(1),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(width: AppTheme.spacingMd),

            // Checkbox Button
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  HapticFeedback.lightImpact();
                  debugPrint('🎯 Habit checkbox tapped: ${widget.habit.name}');
                  ref
                      .read(habitNotifierProvider.notifier)
                      .toggleHabit(widget.habit.id!);
                  // Track for ad frequency (show after 2 completions)
                  ref.read(adFrequencyProvider.notifier).onHabitCompleted(ref);
                },
                borderRadius: BorderRadius.circular(12),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.elasticOut,
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isCompleted ? habitColor : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isCompleted
                          ? habitColor
                          : theme.colorScheme.onSurface.withValues(alpha: 0.2),
                      width: 2,
                    ),
                  ),
                  child: isCompleted
                      ? const Icon(
                          Icons.check_rounded,
                          size: 20,
                          color: Colors.white,
                        )
                          .animate()
                          .scale(duration: 200.ms, curve: Curves.easeOutBack)
                      : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddHabitSheet extends ConsumerStatefulWidget {
  const AddHabitSheet({super.key});

  @override
  ConsumerState<AddHabitSheet> createState() => AddHabitSheetState();
}

class AddHabitSheetState extends ConsumerState<AddHabitSheet> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedEmoji = '⭐';
  HabitCategory _selectedCategory = HabitCategory.personal;
  HabitFrequency _selectedFrequency = HabitFrequency.daily;
  int _targetCount = 1;

  // 50+ emojis organized by category
  final _emojis = [
    // Health & Wellness
    '💧', '🥗', '🍎', '🥦', '🧘', '💊', '🩺', '❤️', '🫀', '🧠',
    // Fitness
    '🏃', '💪', '🚴', '🏋️', '🤸', '⚽', '🏊', '🎾', '🧗', '🚶',
    // Mindfulness & Self-care
    '🧘', '🙏', '😌', '🌸', '✨', '🌙', '☀️', '🌅', '🔮', '🕯️',
    // Learning & Productivity
    '📚', '📖', '✍️', '🎯', '📝', '💻', '🧮', '🎓', '🔬', '📊',
    // Creativity
    '🎨', '🎵', '🎸', '📷', '🎬', '✏️', '🎭', '🪡', '🎹', '🎤',
    // Finance
    '💰', '📈', '💵', '🏦', '💳', '🧾', '💎', '📉', '🪙', '💲',
    // Social
    '👋', '🤝', '💬', '📞', '👨‍👩‍👧', '❤️', '🎁', '🎉', '👥', '🙌',
    // Sleep & Rest
    '💤', '🛏️', '😴', '🌙', '⏰', '☕', '🧹', '🏠', '🚿', '🪥',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppTheme.radiusXl),
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppTheme.spacingLg),

            // Title
            Text(
              'Create New Habit',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppTheme.spacingXl),

            // Emoji selector
            Text(
              'Choose an emoji',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppTheme.spacingSm),
            Wrap(
              spacing: AppTheme.spacingSm,
              children: _emojis.map((emoji) {
                final isSelected = _selectedEmoji == emoji;
                return GestureDetector(
                  onTap: () => setState(() => _selectedEmoji = emoji),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.all(AppTheme.spacingSm),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withValues(alpha: 0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : theme.colorScheme.onSurface
                                .withValues(alpha: 0.1),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Text(emoji, style: const TextStyle(fontSize: 28)),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: AppTheme.spacingLg),

            // Name input
            Text(
              'Habit name',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppTheme.spacingSm),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: 'e.g., Morning Meditation',
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: AppTheme.spacingLg),

            // Description input
            Text(
              'Description (Optional)',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppTheme.spacingSm),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                hintText: 'Motivation or details...',
              ),
              textCapitalization: TextCapitalization.sentences,
              maxLines: 2,
              minLines: 1,
            ),
            const SizedBox(height: AppTheme.spacingLg),

            // Category dropdown
            Text(
              'Category',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppTheme.spacingSm),
            DropdownButtonFormField<HabitCategory>(
              initialValue: _selectedCategory,
              decoration: const InputDecoration(),
              items: HabitCategory.values.map((cat) {
                return DropdownMenuItem(
                  value: cat,
                  child:
                      Text(cat.name[0].toUpperCase() + cat.name.substring(1)),
                );
              }).toList(),
              onChanged: (value) => setState(() => _selectedCategory = value!),
            ),
            const SizedBox(height: AppTheme.spacingLg),

            // Frequency dropdown
            Text(
              'Frequency',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppTheme.spacingSm),
            InputDecorator(
              decoration: const InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<HabitFrequency>(
                  value: _selectedFrequency,
                  isExpanded: true,
                  items: const [
                    DropdownMenuItem(
                      value: HabitFrequency.daily,
                      child: Text('Every Day'),
                    ),
                    DropdownMenuItem(
                      value: HabitFrequency.weekdays,
                      child: Text('Weekdays (Mon-Fri)'),
                    ),
                    DropdownMenuItem(
                      value: HabitFrequency.weekends,
                      child: Text('Weekends (Sat-Sun)'),
                    ),
                  ],
                  onChanged: (value) =>
                      setState(() => _selectedFrequency = value!),
                ),
              ),
            ),
            const SizedBox(height: AppTheme.spacingLg),

            // Target count
            Text(
              'Daily target',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppTheme.spacingSm),
            Row(
              children: [
                IconButton(
                  onPressed: _targetCount > 1
                      ? () => setState(() => _targetCount--)
                      : null,
                  icon: const Icon(Icons.remove_rounded),
                ),
                Text(
                  '$_targetCount',
                  style: theme.textTheme.headlineSmall,
                ),
                IconButton(
                  onPressed: () => setState(() => _targetCount++),
                  icon: const Icon(Icons.add_rounded),
                ),
                const SizedBox(width: AppTheme.spacingMd),
                Text(
                  _targetCount == 1 ? 'time per day' : 'times per day',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingXl),

            // Create button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _createHabit,
                child: const Text('Create Habit'),
              ),
            ),
            const SizedBox(height: AppTheme.spacingMd),
          ],
        ),
      ),
    );
  }

  Future<void> _createHabit() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a habit name')),
      );
      return;
    }

    await ref.read(habitNotifierProvider.notifier).createHabit(
          name: name,
          emoji: _selectedEmoji,
          category: _selectedCategory,
          frequency: _selectedFrequency,
          colorHex: AppColors.categoryColors[_selectedCategory.index]
              .toARGB32()
              .toRadixString(16),
          targetCount: _targetCount,
          description: _descriptionController.text.trim().isEmpty
              ? null
              : _descriptionController.text.trim(),
        );

    if (mounted) {
      Navigator.of(context).pop();
      HapticFeedback.mediumImpact();
    }
  }
}
