import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../core/providers/habit_providers.dart';
import '../../../../core/providers/habit_notifier.dart';
import '../../../habits/data/models/habit.dart';
import '../../../../core/models/priority_enum.dart';
import '../../../../shared/widgets/priority_selector_widget.dart';
import '../../../habits/presentation/widgets/habit_card.dart';

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
              // Sort habits by priority (descending) then sortOrder (ascending)
              final sortedHabits = List<Habit>.from(habits);
              sortedHabits.sort((a, b) {
                final priorityDiff = b.priority.compareTo(a.priority);
                if (priorityDiff != 0) return priorityDiff;
                return a.sortOrder.compareTo(b.sortOrder);
              });

              if (sortedHabits.isEmpty) {
                return _EmptyHabitsState(
                  onAddHabit: () => _showAddHabitSheet(context, ref),
                );
              }

              return Column(
                children: [
                  // Scrollable habits list with max height
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxHeight: 400, // Max height before scrolling
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: sortedHabits
                            .map((habit) => Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: AppTheme.spacingSm),
                                  child: HabitCard(habit: habit),
                                ))
                            .toList(),
                      ),
                    ),
                  ),

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
  HabitPriority _selectedPriority = HabitPriority.medium;
  int _targetCount = 1;
  bool _reminderEnabled = false;
  TimeOfDay? _reminderTime;

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

            // Priority Selector
            PrioritySelectorWidget(
              selectedPriority: _selectedPriority,
              onPriorityChanged: (p) => setState(() => _selectedPriority = p),
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

            // Notifications
            Text(
              'Reminders',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SwitchListTile(
              title: const Text('Enable Notifications'),
              value: _reminderEnabled,
              onChanged: (val) async {
                if (val) {
                  // Request permissions first
                  final granted = await ref
                      .read(notificationServiceProvider)
                      .requestPermissions();
                  if (!granted && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Notification permissions denied')),
                    );
                    return;
                  }
                  // Set default time if null
                  if (_reminderTime == null) {
                    setState(() =>
                        _reminderTime = const TimeOfDay(hour: 9, minute: 0));
                  }
                }
                setState(() => _reminderEnabled = val);
              },
            ),
            if (_reminderEnabled && _reminderTime != null)
              ListTile(
                title: const Text('Reminder Time'),
                trailing: Text(
                  _reminderTime!.format(context),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: _reminderTime!,
                  );
                  if (time != null) {
                    setState(() => _reminderTime = time);
                  }
                },
              ),
            const SizedBox(height: AppTheme.spacingLg),

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
          priority: _selectedPriority.value, // Pass priority value
          colorHex: AppColors.categoryColors[_selectedCategory.index]
              .toARGB32()
              .toRadixString(16),
          targetCount: _targetCount,
          description: _descriptionController.text.trim().isEmpty
              ? null
              : _descriptionController.text.trim(),
          reminderEnabled: _reminderEnabled,
          reminderTime: _reminderEnabled && _reminderTime != null
              ? '${_reminderTime!.hour}:${_reminderTime!.minute.toString().padLeft(2, '0')}'
              : null,
        );

    if (mounted) {
      Navigator.of(context).pop();
      HapticFeedback.mediumImpact();
    }
  }
}
