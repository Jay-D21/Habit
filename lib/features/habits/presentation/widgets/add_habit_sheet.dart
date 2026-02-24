import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/providers/habit_notifier.dart';
import '../../../../core/providers/notification_providers.dart';
import '../../../../shared/widgets/priority_selector_widget.dart';
import '../../../../shared/widgets/icon_emoji_picker.dart';
import '../../../timer/providers/habit_timer_providers.dart';
import '../../../../core/models/priority_enum.dart';
import '../../data/models/habit.dart';

class AddHabitSheet extends ConsumerStatefulWidget {
  const AddHabitSheet({super.key});

  @override
  ConsumerState<AddHabitSheet> createState() => _AddHabitSheetState();
}

class _AddHabitSheetState extends ConsumerState<AddHabitSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _timerDurationController = TextEditingController(text: '15');

  String _emoji = '⭐';
  HabitCategory _category = HabitCategory.health;
  HabitFrequency _frequency = HabitFrequency.daily;
  Color _color = AppColors.primary;
  int _targetCount = 1;
  bool _reminderEnabled = false;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 9, minute: 0);

  // New timer fields
  bool _isTimed = false;

  final _emojis = ['⭐', '🧘', '📚', '💪', '💧', '🏃', '✍️', '🎯', '💤', '🥗'];

  final _colors = [
    const Color(0xFFFF4B4B), // Red
    const Color(0xFFFF7B4B), // Orange
    const Color(0xFFFFB84B), // Amber
    const Color(0xFFFFF14B), // Yellow
    const Color(0xFFD4FF4B), // Lime
    const Color(0xFF4BFF4B), // Green
    const Color(0xFF4BFF9B), // Emerald
    const Color(0xFF4BFFEB), // Cyan
    const Color(0xFF4BB1FF), // Blue
    const Color(0xFF4D4BFF), // Indigo
    const Color(0xFF984BFF), // Purple
    const Color(0xFFE84BFF), // Magenta
    const Color(0xFFFF4BD4), // Pink
    const Color(0xFFFF4B8D), // Rose
    const Color(0xFFE1E1E1), // Light Grey
    const Color(0xFFFF5252), // Material Red
    const Color(0xFF90A4AE), // Blue Grey
    const Color(0xFF78909C), // Steel
  ];

  bool _isAdvancedOpen = false;
  HabitPriority _priority = HabitPriority.medium;

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _timerDurationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Handle
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'New Habit',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
          ),

          Expanded(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  // ─── Top Section ───
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Background belt icons
                      Opacity(
                        opacity: 0.1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: _emojis.take(15).map((e) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child:
                                  Text(e, style: const TextStyle(fontSize: 20)),
                            );
                          }).toList(),
                        ),
                      ),
                      // Circular Icon Preview
                      GestureDetector(
                        onTap: () async {
                          final selected = await Navigator.push<String>(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  IconEmojiPicker(initialValue: _emoji),
                            ),
                          );
                          if (selected != null) {
                            setState(() => _emoji = selected);
                          }
                        },
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.cardDark : Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: buildIconEmojiDisplay(_emoji,
                                size: 36, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Emoji / Icon selector (horizontal)
                  SizedBox(
                    height: 50,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _emojis.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final e = _emojis[index];
                        final isSelected = _emoji == e;
                        return GestureDetector(
                          onTap: () => setState(() => _emoji = e),
                          child: Opacity(
                            opacity: isSelected ? 1.0 : 0.3,
                            child:
                                Text(e, style: const TextStyle(fontSize: 26)),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Name
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      hintText: 'Enter habit name',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'Required' : null,
                  ),
                  const Divider(),
                  const SizedBox(height: 16),

                  // Description
                  TextFormField(
                    controller: _descController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      hintText: 'Enter optional description',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    validator: (v) => null,
                  ),
                  const Divider(),
                  const SizedBox(height: 24),

                  // Color Section
                  Text(
                    'Color',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: _colors.map((color) {
                      final isSelected = _color == color;
                      return GestureDetector(
                        onTap: () => setState(() => _color = color),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(10),
                            border: isSelected
                                ? Border.all(color: Colors.white, width: 2)
                                : null,
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: color.withValues(alpha: 0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    )
                                  ]
                                : null,
                          ),
                          child: isSelected
                              ? const Icon(Icons.check_rounded,
                                  color: Colors.white, size: 20)
                              : null,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 32),
                  // ─── Advanced Options Toggle ───
                  GestureDetector(
                    onTap: () =>
                        setState(() => _isAdvancedOpen = !_isAdvancedOpen),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Advanced Options',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.6),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Icon(
                            _isAdvancedOpen
                                ? Icons.keyboard_arrow_up_rounded
                                : Icons.keyboard_arrow_down_rounded,
                            size: 20,
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.6),
                          ),
                        ],
                      ),
                    ),
                  ),

                  if (_isAdvancedOpen) ...[
                    const SizedBox(height: 16),

                    // Category
                    DropdownButtonFormField<HabitCategory>(
                      initialValue: _category,
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(),
                      ),
                      items: HabitCategory.values.map((c) {
                        return DropdownMenuItem(
                          value: c,
                          child: Text(
                              c.name[0].toUpperCase() + c.name.substring(1)),
                        );
                      }).toList(),
                      onChanged: (val) => setState(() => _category = val!),
                    ),
                    const SizedBox(height: 24),

                    // Priority (Star Selector)
                    PrioritySelectorWidget(
                      selectedPriority: _priority,
                      onPriorityChanged: (p) => setState(() => _priority = p),
                    ),
                    const SizedBox(height: 24),

                    // Frequency
                    DropdownButtonFormField<HabitFrequency>(
                      initialValue: _frequency,
                      decoration: const InputDecoration(
                        labelText: 'Frequency',
                        border: OutlineInputBorder(),
                      ),
                      items: HabitFrequency.values.map((f) {
                        return DropdownMenuItem(
                          value: f,
                          child: Text(
                              f.name[0].toUpperCase() + f.name.substring(1)),
                        );
                      }).toList(),
                      onChanged: (val) => setState(() => _frequency = val!),
                    ),
                    const SizedBox(height: 24),

                    // Daily Target (+/-)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Daily target',
                            style: TextStyle(fontWeight: FontWeight.w500)),
                        Row(
                          children: [
                            IconButton(
                              onPressed: _targetCount > 1
                                  ? () => setState(() => _targetCount--)
                                  : null,
                              icon: const Icon(Icons.remove_rounded),
                              visualDensity: VisualDensity.compact,
                            ),
                            Text('$_targetCount',
                                style: theme.textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold)),
                            IconButton(
                              onPressed: () => setState(() => _targetCount++),
                              icon: const Icon(Icons.add_rounded),
                              visualDensity: VisualDensity.compact,
                            ),
                            const SizedBox(width: 8),
                            Text('time per day',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurface
                                        .withValues(alpha: 0.6))),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Timer Mode
                    const Text('Timer Mode',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Enable Timer'),
                      subtitle: const Text('Start a countdown and enable DND'),
                      value: _isTimed,
                      onChanged: (val) async {
                        if (val) {
                          final dnd = ref.read(dndServiceProvider);
                          final hasPermission = await dnd.checkPermissions();
                          if (!hasPermission) {
                            await dnd.requestPermissions();
                          }
                        }
                        setState(() => _isTimed = val);
                      },
                    ),
                    if (_isTimed) ...[
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _timerDurationController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Duration (minutes)',
                          border: OutlineInputBorder(),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ],
                    const SizedBox(height: 24),

                    // Reminders
                    const Text('Reminders',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Enable Notifications'),
                      value: _reminderEnabled,
                      onChanged: (val) async {
                        if (val) {
                          // Show loading or just wait
                          final granted = await ref
                              .read(notificationServiceProvider)
                              .requestPermissions();
                          if (!granted && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Please grant notification and alarm permissions in settings.')),
                            );
                            return;
                          }
                        }
                        setState(() => _reminderEnabled = val);
                      },
                    ),
                    if (_reminderEnabled) ...[
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Time'),
                        trailing: Text(
                          _reminderTime.format(context),
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: _reminderTime,
                          );
                          if (time != null) {
                            setState(() => _reminderTime = time);
                          }
                        },
                      ),
                    ],
                  ],
                  const SizedBox(height: 48),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: FilledButton(
                      onPressed: _submit,
                      style: FilledButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Save',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final colorHex = _color.toARGB32().toRadixString(16).padLeft(8, '0');
    final reminderTimeStr =
        '${_reminderTime.hour}:${_reminderTime.minute.toString().padLeft(2, '0')}';

    try {
      await ref.read(habitNotifierProvider.notifier).createHabit(
            name: _nameController.text.trim(),
            emoji: _emoji,
            category: _category,
            frequency: _frequency,
            colorHex: colorHex,
            targetCount: _targetCount,
            priority: _priority.value,
            description: _descController.text.trim().isEmpty
                ? null
                : _descController.text.trim(),
            reminderEnabled: _reminderEnabled,
            reminderTime: reminderTimeStr,
            isTimed: _isTimed,
            timerDuration: _isTimed
                ? (int.tryParse(_timerDurationController.text) ?? 15)
                : null,
          );

      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Habit created successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }
}
