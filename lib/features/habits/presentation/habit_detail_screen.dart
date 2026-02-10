import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/providers/habit_providers.dart';
import '../../../core/providers/habit_notifier.dart';
import '../data/models/habit.dart';

/// Habit detail screen
class HabitDetailScreen extends ConsumerWidget {
  final String habitId;

  const HabitDetailScreen({super.key, required this.habitId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final id = int.tryParse(habitId) ?? 0;
    final habitAsync = ref.watch(habitProvider(id));
    final streakAsync = ref.watch(habitStreakProvider(id));

    return habitAsync.when(
      data: (habit) {
        if (habit == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Habit Not Found')),
            body: const Center(child: Text('This habit does not exist.')),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(habit.name),
            actions: [
              IconButton(
                onPressed: () => _showEditSheet(context, ref, habit),
                icon: const Icon(Icons.edit_rounded),
              ),
              IconButton(
                onPressed: () => _confirmDelete(context, ref, habit),
                icon: const Icon(Icons.delete_rounded, color: AppColors.error),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(AppTheme.spacingLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Habit card
                Container(
                  padding: const EdgeInsets.all(AppTheme.spacingXl),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardDark : AppColors.cardLight,
                    borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                    border: Border.all(
                      color:
                          isDark ? AppColors.borderDark : AppColors.borderLight,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(habit.emoji, style: const TextStyle(fontSize: 64)),
                      const SizedBox(height: AppTheme.spacingMd),
                      Text(
                        habit.name,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (habit.description != null) ...[
                        const SizedBox(height: AppTheme.spacingSm),
                        Text(
                          habit.description!,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.6),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: AppTheme.spacingLg),

                // Stats row
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        icon: Icons.local_fire_department_rounded,
                        value: streakAsync.when(
                          data: (streak) => '$streak',
                          loading: () => '-',
                          error: (_, __) => '0',
                        ),
                        label: 'Current Streak',
                        color: AppColors.accent,
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacingMd),
                    Expanded(
                      child: _StatCard(
                        icon: Icons.repeat_rounded,
                        value: habit.frequency.name,
                        label: 'Frequency',
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.spacingMd),
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        icon: Icons.category_rounded,
                        value: habit.category.name,
                        label: 'Category',
                        color: AppColors.success,
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacingMd),
                    Expanded(
                      child: _StatCard(
                        icon: Icons.flag_rounded,
                        value: '${habit.targetCount}x',
                        label: 'Daily Target',
                        color: AppColors.warning,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.spacingXl),

                // Complete button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      HapticFeedback.mediumImpact();
                      await ref
                          .read(habitNotifierProvider.notifier)
                          .completeHabit(id);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Habit completed! 🎉')),
                        );
                      }
                    },
                    icon: const Icon(Icons.check_rounded),
                    label: const Text('Complete for Today'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: AppTheme.spacingMd),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(child: Text('Error: $error')),
      ),
    );
  }

  void _showEditSheet(BuildContext context, WidgetRef ref, Habit habit) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _EditHabitSheet(habit: habit),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, Habit habit) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Habit'),
        content: Text(
            'Are you sure you want to delete "${habit.name}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              // Delete the habit
              await ref
                  .read(habitNotifierProvider.notifier)
                  .deleteHabit(habit.id!);

              // Force refresh of habit providers
              ref.invalidate(habitsProvider);
              ref.invalidate(todayCompletionsProvider);
              ref.invalidate(overallStreakProvider);

              if (dialogContext.mounted) {
                Navigator.of(dialogContext).pop();
              }
              if (context.mounted) {
                context.go('/habits');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${habit.name} deleted')),
                );
              }
            },
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
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

    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.2 : 0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: AppTheme.spacingXs),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}

class _EditHabitSheet extends ConsumerStatefulWidget {
  final Habit habit;

  const _EditHabitSheet({required this.habit});

  @override
  ConsumerState<_EditHabitSheet> createState() => _EditHabitSheetState();
}

class _EditHabitSheetState extends ConsumerState<_EditHabitSheet> {
  late TextEditingController _nameController;
  late String _selectedEmoji;
  late int _targetCount;
  late bool _reminderEnabled;
  TimeOfDay? _reminderTime;

  final _emojis = ['⭐', '🧘', '📚', '💪', '💧', '🏃', '✍️', '🎯', '💤', '🥗'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.habit.name);
    _selectedEmoji = widget.habit.emoji;
    _targetCount = widget.habit.targetCount;
    _reminderEnabled = widget.habit.reminderEnabled;
    if (widget.habit.reminderTime != null) {
      final parts = widget.habit.reminderTime!.split(':');
      _reminderTime =
          TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
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
              'Edit Habit',
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

            // Save button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveHabit,
                child: const Text('Save Changes'),
              ),
            ),
            const SizedBox(height: AppTheme.spacingMd),
          ],
        ),
      ),
    );
  }

  Future<void> _saveHabit() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a habit name')),
      );
      return;
    }

    final updatedHabit = widget.habit.copyWith(
      name: name,
      emoji: _selectedEmoji,
      targetCount: _targetCount,
      reminderEnabled: _reminderEnabled,
      reminderTime: _reminderEnabled && _reminderTime != null
          ? '${_reminderTime!.hour}:${_reminderTime!.minute.toString().padLeft(2, '0')}'
          : null,
    );

    await ref.read(habitNotifierProvider.notifier).updateHabit(updatedHabit);

    if (mounted) {
      Navigator.of(context).pop();
      HapticFeedback.mediumImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Habit updated!')),
      );
    }
  }
}
