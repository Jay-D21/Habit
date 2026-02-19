import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/providers/journal_notifier.dart';
import '../data/models/journal_entry.dart';
import '../data/models/journal_template.dart';
import 'widgets/audio_player_widget.dart';
import 'widgets/voice_recorder_sheet.dart';

import '../../../main.dart'; // Import global database

/// Journal entry creation/editing screen
class JournalEntryScreen extends ConsumerStatefulWidget {
  final JournalEntryModel? entry; // For editing
  final int? entryId; // For editing by ID if entry object not passed
  final JournalTemplate? template; // For creating from template
  final int? diaryId; // For creating in specific diary
  final DateTime? date; // For creating on specific date

  const JournalEntryScreen({
    super.key,
    this.entry,
    this.entryId,
    this.template,
    this.diaryId,
    this.date,
  });

  @override
  ConsumerState<JournalEntryScreen> createState() => _JournalEntryScreenState();
}

class _JournalEntryScreenState extends ConsumerState<JournalEntryScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  // Custom Icon & Color
  int _selectedIconCodePoint = Icons.article_rounded.codePoint;
  int _selectedColorValue = AppColors.primary.toARGB32();

  String? _voiceNotePath;
  bool _isLoading = false;
  late DateTime _entryDate;
  int? _diaryId;

  bool get _isEditing => widget.entry != null || widget.entryId != null;

  final List<IconData> _availableIcons = [
    Icons.article_rounded,
    Icons.star_rounded,
    Icons.work_rounded,
    Icons.person_rounded,
    Icons.fitness_center_rounded,
    Icons.restaurant_rounded,
    Icons.flight_rounded,
    Icons.music_note_rounded,
    Icons.local_cafe_rounded,
    Icons.bed_rounded,
    Icons.favorite_rounded,
    Icons.shopping_bag_rounded,
    Icons.wb_sunny_rounded,
    Icons.school_rounded,
    Icons.pets_rounded,
  ];

  final List<Color> _availableColors = [
    AppColors.primary,
    AppColors.secondary,
    AppColors.accent,
    AppColors.success,
    AppColors.error,
    Colors.purple,
    Colors.teal,
    Colors.indigo,
    Colors.brown,
    Colors.blueGrey,
  ];

  @override
  void initState() {
    super.initState();
    _entryDate = widget.date ?? DateTime.now();
    _diaryId = widget.diaryId;

    if (widget.entry != null) {
      _initializeFromEntry(widget.entry!);
    } else if (widget.entryId != null) {
      _loadEntry(widget.entryId!);
    } else if (widget.template != null) {
      _applyTemplate(widget.template!);
    }
  }

  void _initializeFromEntry(JournalEntryModel entry) {
    _titleController.text = entry.title;
    _contentController.text = entry.content;
    _entryDate = entry.date;
    _diaryId = entry.diaryId;
    _voiceNotePath = entry.voiceNotePath;

    if (entry.iconCodePoint != null) {
      _selectedIconCodePoint = entry.iconCodePoint!;
    }
    if (entry.iconColor != null) {
      _selectedColorValue = entry.iconColor!;
    }
  }

  Future<void> _loadEntry(int id) async {
    setState(() => _isLoading = true);
    try {
      final entry = await database.getJournalEntryById(id);
      if (entry != null && mounted) {
        // Need to map DB entry to Model or just use fields
        // Current database.getJournalEntryById via provider usually returns Model or Entity
        // Let's assume it returns the Entry Entity or Model.
        // Actually in Notifier it returns JournalEntryModel.
        // Wait, `database.getJournalEntryById` is likely from `AppDatabase`.
        // In `database.dart`, `getJournalEntryById` returns `JournalEntry?` (the entity).

        _titleController.text = entry.title;
        _contentController.text = entry.content;
        _entryDate = entry.date;
        _diaryId = entry.diaryId;
        _voiceNotePath = entry.voiceNotePath;

        if (entry.iconCodePoint != null) {
          _selectedIconCodePoint = entry.iconCodePoint!;
        }
        if (entry.iconColor != null) {
          _selectedColorValue = entry.iconColor!;
        }

        setState(() {});
      }
    } catch (e) {
      debugPrint('Error loading entry: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _applyTemplate(JournalTemplate template) {
    _titleController.text = template.titleTemplate.replaceAll('{date}', '');
    // Templates might dictate icon/color in future, for now use defaults

    final buffer = StringBuffer();
    for (var prompt in template.prompts) {
      buffer.writeln('**$prompt**');
      buffer.writeln(''); // Space for answer
      buffer.writeln('');
    }
    _contentController.text = buffer.toString();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _showRecordingSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => VoiceRecorderSheet(
        onRecordingComplete: (path) {
          setState(() => _voiceNotePath = path);
        },
      ),
    );
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

    // Ensure we have a diaryId. If null, we might need to pick one or default.
    // For now, if null, we'll try to use the default 'My Journal' (ID 1 usually).
    // Or we should block and ask user?
    // Let's fallback to 1 for migration safety, but ideally we should have passed it.
    final targetDiaryId = _diaryId ?? 1;

    try {
      if (_isEditing) {
        final id = widget.entry?.id ?? widget.entryId!;
        await ref.read(journalNotifierProvider.notifier).updateEntry(
              id: id,
              title: title,
              content: content,
              date: _entryDate,
              iconCodePoint: _selectedIconCodePoint,
              iconColor: _selectedColorValue,
              voiceNotePath: _voiceNotePath,
            );
      } else {
        await ref.read(journalNotifierProvider.notifier).createEntry(
              diaryId: targetDiaryId,
              title: title,
              content: content,
              date: _entryDate,
              iconCodePoint: _selectedIconCodePoint,
              iconColor: _selectedColorValue,
              voiceNotePath: _voiceNotePath,
            );
      }

      HapticFeedback.mediumImpact();

      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Journal entry saved! 📝')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving entry: $e')),
        );
      }
    }
  }

  void _openIconPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 400,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(AppTheme.spacingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Choose Icon', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppTheme.spacingMd),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: _availableIcons.length,
                itemBuilder: (context, index) {
                  final icon = _availableIcons[index];
                  final isSelected = _selectedIconCodePoint == icon.codePoint;
                  return InkWell(
                    onTap: () {
                      setState(() => _selectedIconCodePoint = icon.codePoint);
                      Navigator.pop(context);
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Color(_selectedColorValue).withValues(alpha: 0.2)
                            : null,
                        border: isSelected
                            ? Border.all(
                                color: Color(_selectedColorValue), width: 2)
                            : null,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon,
                          color: Color(_selectedColorValue), size: 30),
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

  void _openColorPicker() {
    // Simple horizontal list for now
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 180,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(AppTheme.spacingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Choose Color', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppTheme.spacingMd),
            SizedBox(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _availableColors.length,
                itemBuilder: (context, index) {
                  final color = _availableColors[index];
                  final isSelected = _selectedColorValue == color.toARGB32();
                  return InkWell(
                    onTap: () {
                      setState(() => _selectedColorValue = color.toARGB32());
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(color: Colors.white, width: 3)
                            : null,
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                    color: color.withValues(alpha: 0.5),
                                    blurRadius: 8)
                              ]
                            : null,
                      ),
                      child: isSelected
                          ? const Icon(Icons.check, color: Colors.white)
                          : null,
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: Text(_isEditing ? 'Edit Entry' : 'New Entry'),
        actions: [
          // Date Picker
          TextButton.icon(
            onPressed: () async {
              final picked = await showDatePicker(
                  context: context,
                  initialDate: _entryDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100));
              if (picked != null) {
                setState(() => _entryDate = picked);
              }
            },
            icon: const Icon(Icons.calendar_today_rounded, size: 16),
            label: Text(DateFormat('MMM d').format(_entryDate)),
          ),
          const SizedBox(width: 8),

          FilledButton.tonal(
            onPressed: _saveEntry,
            child: const Text('Save'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Icon & Color
            Row(
              children: [
                InkWell(
                  onTap: _openIconPicker,
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Color(_selectedColorValue).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: Color(_selectedColorValue)
                              .withValues(alpha: 0.3)),
                    ),
                    child: Icon(
                      IconData(_selectedIconCodePoint,
                          fontFamily: 'MaterialIcons'),
                      color: Color(_selectedColorValue),
                      size: 32,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                InkWell(
                  onTap: _openColorPicker,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Color(_selectedColorValue),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color:
                              Color(_selectedColorValue).withValues(alpha: 0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppTheme.spacingLg),

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

            // Content
            Container(
              constraints: const BoxConstraints(minHeight: 300),
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
                style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
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

            // Voice Note Section
            if (_voiceNotePath != null)
              AudioPlayerWidget(
                audioPath: _voiceNotePath!,
                onDelete: () {
                  setState(() => _voiceNotePath = null);
                },
              )
            else
              OutlinedButton.icon(
                onPressed: _showRecordingSheet,
                icon: const Icon(Icons.mic_rounded),
                label: const Text('Add Voice Note'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                ),
              ),

            const SizedBox(height: AppTheme.spacingXl),
          ],
        ),
      ),
    );
  }
}
