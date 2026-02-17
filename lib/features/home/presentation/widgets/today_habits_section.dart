import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../core/providers/habit_providers.dart';
import '../../../../core/providers/habit_notifier.dart';
import '../../../../core/providers/notification_providers.dart';
import '../../../habits/data/models/habit.dart';
import '../../../../core/models/priority_enum.dart';
import '../../../../shared/widgets/priority_selector_widget.dart';
import '../../../habits/presentation/widgets/habit_card.dart';
import '../../../../shared/widgets/icon_emoji_picker.dart';

/// Today's habits section with habit list
class TodayHabitsSection extends ConsumerWidget {
  const TodayHabitsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final habitsAsync = ref.watch(habitsProvider);
    final completionsAsync = ref.watch(todayCompletionsProvider);

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
                style: theme.textTheme.headlineSmall?.copyWith(
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
              return completionsAsync.when(
                data: (completions) {
                  // Sort habits:
                  // 1. Incomplete first
                  // 2. High priority first
                  // 3. Custom sort order
                  final sortedHabits = List<Habit>.from(habits);
                  sortedHabits.sort((a, b) {
                    final aComp = completions
                        .where((c) => c.habitId == a.id)
                        .fold(0, (sum, c) => sum + c.count);
                    final bComp = completions
                        .where((c) => c.habitId == b.id)
                        .fold(0, (sum, c) => sum + c.count);

                    final aIsDone = aComp >= a.targetCount;
                    final bIsDone = bComp >= b.targetCount;

                    if (aIsDone != bIsDone) {
                      return aIsDone ? 1 : -1; // Incomplete first
                    }

                    final priorityDiff = b.priority.compareTo(a.priority);
                    if (priorityDiff != 0) return priorityDiff;
                    return a.sortOrder.compareTo(b.sortOrder);
                  });

                  // If no habits exist
                  if (sortedHabits.isEmpty) {
                    return _EmptyHabitsState(
                      onAddHabit: () => _showAddHabitSheet(context, ref),
                    );
                  }

                  return Column(
                    children: sortedHabits
                        .map((habit) => Padding(
                              padding: const EdgeInsets.only(
                                  bottom: AppTheme.spacingSm),
                              child: HabitCard(habit: habit),
                            ))
                        .toList(),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Text('Error loading completions: $e'),
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
  bool _showAdvanced = false;
  int _selectedColorIndex = 0;

  // Vibrant color palette matching the screenshots
  static const _colorPalette = <Color>[
    Color(0xFFFF2D55), // Coral/Red
    Color(0xFFFF6B35), // Orange
    Color(0xFFFF9500), // Deep Orange
    Color(0xFFFFCC00), // Yellow
    Color(0xFFC8E600), // Yellow-Green
    Color(0xFF34C759), // Green
    Color(0xFF30D158), // Bright Green
    Color(0xFF00C7BE), // Teal
    Color(0xFF32D6E2), // Cyan
    Color(0xFF5AC8FA), // Light Blue
    Color(0xFF007AFF), // Blue
    Color(0xFF5856D6), // Indigo
    Color(0xFFAF52DE), // Purple
    Color(0xFFFF2D96), // Magenta
    Color(0xFFFF6B81), // Pink
    Color(0xFFFF69B4), // Hot Pink
    Color(0xFFB0BEC5), // Blue-Grey Light
    Color(0xFFFF4081), // Pink accent
    Color(0xFF90A4AE), // Grey-Blue
    Color(0xFF78909C), // Blue-Grey
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
    final selectedColor = _colorPalette[_selectedColorIndex];

    return Container(
      height: MediaQuery.of(context).size.height * 0.92,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppTheme.radiusXl),
        ),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 12, 16, 0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.close_rounded,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                Text(
                  'New Habit',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon preview with faded grid background
                  _buildIconPreview(theme, isDark, selectedColor),
                  const SizedBox(height: 24),

                  // Name
                  Text('Name',
                      style: theme.textTheme.labelLarge
                          ?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor:
                          isDark ? AppColors.cardDark : AppColors.cardLight,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    textCapitalization: TextCapitalization.words,
                  ),
                  const SizedBox(height: 20),

                  // Description
                  Text('Description',
                      style: theme.textTheme.labelLarge
                          ?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor:
                          isDark ? AppColors.cardDark : AppColors.cardLight,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    textCapitalization: TextCapitalization.sentences,
                    maxLines: 2,
                    minLines: 1,
                  ),
                  const SizedBox(height: 20),

                  // Color
                  Text('Color',
                      style: theme.textTheme.labelLarge
                          ?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  _buildColorGrid(isDark),
                  const SizedBox(height: 20),

                  // Advanced Options (collapsible)
                  _buildAdvancedOptions(theme, isDark),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // Save button
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _createHabit,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text('Save',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconPreview(ThemeData theme, bool isDark, Color selectedColor) {
    return GestureDetector(
      onTap: _openIconPicker,
      child: SizedBox(
        height: 140,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Faded icon grid background
            const Opacity(
              opacity: 0.15,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: [
                  Icon(Icons.camera_alt_outlined, size: 20),
                  Icon(Icons.podcasts_outlined, size: 20),
                  Icon(Icons.directions_run_outlined, size: 20),
                  Icon(Icons.self_improvement_outlined, size: 20),
                  Icon(Icons.fitness_center_outlined, size: 20),
                  Icon(Icons.menu_book_outlined, size: 20),
                  Icon(Icons.music_note_outlined, size: 20),
                  Icon(Icons.code_outlined, size: 20),
                  Icon(Icons.palette_outlined, size: 20),
                  Icon(Icons.water_drop_outlined, size: 20),
                  Icon(Icons.restaurant_outlined, size: 20),
                  Icon(Icons.school_outlined, size: 20),
                  Icon(Icons.directions_bike_outlined, size: 20),
                  Icon(Icons.spa_outlined, size: 20),
                  Icon(Icons.work_outline, size: 20),
                  Icon(Icons.home_outlined, size: 20),
                  Icon(Icons.headphones_outlined, size: 20),
                  Icon(Icons.piano_outlined, size: 20),
                  Icon(Icons.hiking_outlined, size: 20),
                  Icon(Icons.savings_outlined, size: 20),
                  Icon(Icons.pets_outlined, size: 20),
                  Icon(Icons.nightlife_outlined, size: 20),
                  Icon(Icons.coffee_outlined, size: 20),
                  Icon(Icons.sports_basketball_outlined, size: 20),
                  Icon(Icons.photo_camera_outlined, size: 20),
                  Icon(Icons.bed_outlined, size: 20),
                  Icon(Icons.task_alt_outlined, size: 20),
                  Icon(Icons.laptop_mac_outlined, size: 20),
                  Icon(Icons.local_hospital_outlined, size: 20),
                  Icon(Icons.brush_outlined, size: 20),
                  Icon(Icons.forum_outlined, size: 20),
                  Icon(Icons.yard_outlined, size: 20),
                ],
              ),
            ),
            // Large circular preview
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark ? Colors.grey.shade900 : Colors.grey.shade200,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 16,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Center(
                child: buildIconEmojiDisplay(_selectedEmoji,
                    size: 36, color: theme.colorScheme.onSurface),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorGrid(bool isDark) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: _colorPalette.asMap().entries.map((entry) {
        final index = entry.key;
        final color = entry.value;
        final isSelected = _selectedColorIndex == index;
        return GestureDetector(
          onTap: () => setState(() => _selectedColorIndex = index),
          child: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
              border: isSelected
                  ? Border.all(
                      color: isDark ? Colors.white : Colors.black, width: 2.5)
                  : null,
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                          color: color.withValues(alpha: 0.5),
                          blurRadius: 8,
                          spreadRadius: 1)
                    ]
                  : null,
            ),
            child: isSelected
                ? const Icon(Icons.check_rounded, color: Colors.white, size: 18)
                : null,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAdvancedOptions(ThemeData theme, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => setState(() => _showAdvanced = !_showAdvanced),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Advanced Options',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
              Icon(
                _showAdvanced
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                size: 20,
              ),
            ],
          ),
        ),
        if (_showAdvanced) ...[
          const SizedBox(height: 16),

          // Category
          Text('Category',
              style: theme.textTheme.labelLarge
                  ?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          DropdownButtonFormField<HabitCategory>(
            initialValue: _selectedCategory,
            decoration: InputDecoration(
              filled: true,
              fillColor: isDark ? AppColors.cardDark : AppColors.cardLight,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            items: HabitCategory.values.map((cat) {
              return DropdownMenuItem(
                value: cat,
                child: Text(cat.name[0].toUpperCase() + cat.name.substring(1)),
              );
            }).toList(),
            onChanged: (value) => setState(() => _selectedCategory = value!),
          ),
          const SizedBox(height: 16),

          // Priority
          PrioritySelectorWidget(
            selectedPriority: _selectedPriority,
            onPriorityChanged: (p) => setState(() => _selectedPriority = p),
          ),
          const SizedBox(height: 16),

          // Frequency
          Text('Frequency',
              style: theme.textTheme.labelLarge
                  ?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          InputDecorator(
            decoration: InputDecoration(
              filled: true,
              fillColor: isDark ? AppColors.cardDark : AppColors.cardLight,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
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
          const SizedBox(height: 16),

          // Target count
          Text('Daily target',
              style: theme.textTheme.labelLarge
                  ?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Row(
            children: [
              IconButton(
                onPressed: _targetCount > 1
                    ? () => setState(() => _targetCount--)
                    : null,
                icon: const Icon(Icons.remove_rounded),
              ),
              Text('$_targetCount', style: theme.textTheme.headlineSmall),
              IconButton(
                onPressed: () => setState(() => _targetCount++),
                icon: const Icon(Icons.add_rounded),
              ),
              const SizedBox(width: 8),
              Text(
                _targetCount == 1 ? 'time per day' : 'times per day',
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Reminders
          Text('Reminders',
              style: theme.textTheme.labelLarge
                  ?.copyWith(fontWeight: FontWeight.w600)),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Enable Notifications'),
            value: _reminderEnabled,
            onChanged: (val) async {
              if (val) {
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
              contentPadding: EdgeInsets.zero,
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
        ],
      ],
    );
  }

  Future<void> _openIconPicker() async {
    final result = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (_) => IconEmojiPicker(initialValue: _selectedEmoji),
      ),
    );
    if (result != null) {
      setState(() => _selectedEmoji = result);
    }
  }

  Future<void> _createHabit() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a habit name')),
      );
      return;
    }

    final color = _colorPalette[_selectedColorIndex];

    await ref.read(habitNotifierProvider.notifier).createHabit(
          name: name,
          emoji: _selectedEmoji,
          category: _selectedCategory,
          frequency: _selectedFrequency,
          priority: _selectedPriority.value,
          colorHex: color.toARGB32().toRadixString(16),
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
