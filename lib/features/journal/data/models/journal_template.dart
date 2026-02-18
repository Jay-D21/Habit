import 'package:flutter/material.dart';

enum JournalTemplateCategory {
  daily,
  weekly,
  wellness,
  productivity,
  manifestation,
  gratitude,
  reflection,
}

class JournalTemplateKeyResult {
  final IconData icon;
  final String label;
  final String description;

  const JournalTemplateKeyResult({
    required this.icon,
    required this.label,
    required this.description,
  });
}

class JournalTemplateTimelineItem {
  final String dayRange;
  final String title;
  final String description;

  const JournalTemplateTimelineItem({
    required this.dayRange,
    required this.title,
    required this.description,
  });
}

class JournalTemplate {
  final String id;
  final String name;
  final String description;
  final String longDescription; // For the detail screen
  final JournalTemplateCategory category;
  final IconData icon;
  final Color color;
  final String headerImageUrl; // Asset path
  final String
      titleTemplate; // Template for the title, e.g., "Daily Reflection - {date}"
  final List<String> prompts; // List of prompts/questions
  final String estimatedDuration; // e.g., "5 min"

  // Rich content fields
  final List<JournalTemplateKeyResult> keyResults;
  final List<String> expectations;
  final List<JournalTemplateTimelineItem> timeline;

  const JournalTemplate({
    required this.id,
    required this.name,
    required this.description,
    this.longDescription = '',
    required this.category,
    required this.icon,
    required this.color,
    this.headerImageUrl = '',
    required this.titleTemplate,
    required this.prompts,
    required this.estimatedDuration,
    this.keyResults = const [],
    this.expectations = const [],
    this.timeline = const [],
  });
}
