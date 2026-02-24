import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/providers/habit_notifier.dart';
import '../../../../core/providers/notification_providers.dart';
import '../../../timer/providers/habit_timer_providers.dart';
import '../../data/models/habit.dart';

// No color_picker_sheet.dart import needed as we inline it

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
  final int _priority = 3; // Medium
  bool _reminderEnabled = false;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 9, minute: 0);

  // New timer fields
  bool _isTimed = false;

  final _emojis = ['⭐', '🧘', '📚', '💪', '💧', '🏃', '✍️', '🎯', '💤', '🥗'];

  final _colors = [
    const Color(0xFF6C5CE7), // Purple
    const Color(0xFF0984E3), // Blue
    const Color(0xFF00B894), // Green
    const Color(0xFFFD79A8), // Pink
    const Color(0xFFFF7675), // Red
    const Color(0xFFFF9F43), // Orange
    const Color(0xFF636E72), // Grey
  ];

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
                  // Emoji & Color
                  Row(
                    children: [
                      GestureDetector(
                        onTap: _showEmojiPicker,
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: _color.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: _color, width: 2),
                          ),
                          child: Center(
                            child: Text(_emoji,
                                style: const TextStyle(fontSize: 32)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: SizedBox(
                          height: 60,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: _colors.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 8),
                            itemBuilder: (context, index) {
                              final color = _colors[index];
                              final isSelected = _color == color;
                              return GestureDetector(
                                onTap: () => setState(() => _color = color),
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: color,
                                    shape: BoxShape.circle,
                                    border: isSelected
                                        ? Border.all(
                                            color: Colors.white, width: 3)
                                        : null,
                                    boxShadow: isSelected
                                        ? [
                                            BoxShadow(
                                              color:
                                                  color.withValues(alpha: 0.4),
                                              blurRadius: 8,
                                              offset: const Offset(0, 4),
                                            )
                                          ]
                                        : null,
                                  ),
                                  child: isSelected
                                      ? const Icon(Icons.check,
                                          color: Colors.white, size: 20)
                                      : null,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Name
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Habit Name',
                      hintText: 'e.g., Read for 30 mins',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.edit_rounded),
                    ),
                    textCapitalization: TextCapitalization.sentences,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Frequency & Category
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<HabitCategory>(
                          initialValue: _category,
                          decoration: InputDecoration(
                            labelText: 'Category',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          items: HabitCategory.values.map((c) {
                            return DropdownMenuItem(
                              value: c,
                              child: Text(c.name[0].toUpperCase() +
                                  c.name.substring(1)),
                            );
                          }).toList(),
                          onChanged: (val) => setState(() => _category = val!),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButtonFormField<HabitFrequency>(
                          initialValue: _frequency,
                          decoration: InputDecoration(
                            labelText: 'Frequency',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          items: HabitFrequency.values.map((f) {
                            return DropdownMenuItem(
                              value: f,
                              child: Text(f.name[0].toUpperCase() +
                                  f.name.substring(1)),
                            );
                          }).toList(),
                          onChanged: (val) => setState(() => _frequency = val!),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Target Count
                  const _SectionHeader(title: 'Daily Goal'),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.cardDark : AppColors.cardLight,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.1),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Times per day', style: theme.textTheme.bodyLarge),
                        Row(
                          children: [
                            IconButton(
                              onPressed: _targetCount > 1
                                  ? () => setState(() => _targetCount--)
                                  : null,
                              icon: const Icon(Icons.remove_circle_outline),
                            ),
                            SizedBox(
                              width: 32,
                              child: Text(
                                '$_targetCount',
                                textAlign: TextAlign.center,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () => setState(() => _targetCount++),
                              icon: const Icon(Icons.add_circle_outline),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Timed Habit Toggle
                  const _SectionHeader(title: 'Timer Mode'),
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.cardDark : AppColors.cardLight,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.1),
                      ),
                    ),
                    child: Column(
                      children: [
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Enable Timer'),
                          subtitle:
                              const Text('Start a countdown and enable DND'),
                          value: _isTimed,
                          onChanged: (val) async {
                            if (val) {
                              final dnd = ref.read(dndServiceProvider);
                              final hasPermission =
                                  await dnd.checkPermissions();
                              if (!hasPermission) {
                                await dnd.requestPermissions();
                              }
                            }
                            setState(() => _isTimed = val);
                          },
                        ),
                        if (_isTimed) ...[
                          const Divider(),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Duration',
                                    style: theme.textTheme.bodyLarge),
                                SizedBox(
                                  width: 120,
                                  child: TextFormField(
                                    controller: _timerDurationController,
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.right,
                                    decoration: InputDecoration(
                                      suffixText: ' min',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 8),
                                    ),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Reminder
                  const _SectionHeader(title: 'Notifications'),
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.cardDark : AppColors.cardLight,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.1),
                      ),
                    ),
                    child: Column(
                      children: [
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Enable Reminder'),
                          value: _reminderEnabled,
                          onChanged: (val) async {
                            if (val) {
                              final granted = await ref
                                  .read(notificationServiceProvider)
                                  .requestPermissions();
                              if (!granted && context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Permission denied')),
                                );
                                return;
                              }
                            }
                            setState(() => _reminderEnabled = val);
                          },
                        ),
                        if (_reminderEnabled) ...[
                          const Divider(),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('Time'),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: _color.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                _reminderTime.format(context),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: _color,
                                ),
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
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: FilledButton(
                      onPressed: _submit,
                      style: FilledButton.styleFrom(
                        backgroundColor: _color,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Create Habit',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEmojiPicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        height: 300,
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text('Pick an Emoji',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                ),
                itemCount: _emojis.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() => _emoji = _emojis[index]);
                      context.pop();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: _emoji == _emojis[index]
                            ? AppColors.primary.withValues(alpha: 0.1)
                            : null,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(_emojis[index],
                            style: const TextStyle(fontSize: 32)),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
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
            priority: _priority,
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

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color:
                Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
          ),
    );
  }
}
