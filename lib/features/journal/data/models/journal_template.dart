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

class JournalTemplate {
  final String id;
  final String name;
  final String description;
  final JournalTemplateCategory category;
  final IconData icon;
  final Color color;
  final String
      titleTemplate; // Template for the title, e.g., "Daily Reflection - {date}"
  final List<String> prompts; // List of prompts/questions
  final String estimatedDuration; // e.g., "5 min"

  const JournalTemplate({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.icon,
    required this.color,
    required this.titleTemplate,
    required this.prompts,
    required this.estimatedDuration,
  });
}
