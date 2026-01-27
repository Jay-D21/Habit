/// Mood enum for journal entries
enum Mood {
  happy,
  neutral,
  sad,
  angry,
  calm,
}

/// Journal entry model class (pure Dart, no Isar dependencies)
class JournalEntryModel {
  final int? id;
  final String title;
  final String content;
  final DateTime date;
  final Mood mood;
  final String? tags;
  final String? voiceNotePath;
  final bool hasVoiceNote;
  final int wordCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  JournalEntryModel({
    this.id,
    required this.title,
    required this.content,
    required this.date,
    this.mood = Mood.neutral,
    this.tags,
    this.voiceNotePath,
    this.hasVoiceNote = false,
    this.wordCount = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Get emoji for the mood
  String get moodEmoji {
    switch (mood) {
      case Mood.happy:
        return '😊';
      case Mood.neutral:
        return '😐';
      case Mood.sad:
        return '😔';
      case Mood.angry:
        return '😠';
      case Mood.calm:
        return '😌';
    }
  }

  /// Get tags as list
  List<String> get tagsList {
    if (tags == null || tags!.isEmpty) return [];
    return tags!.split(',').map((e) => e.trim()).toList();
  }

  /// Create a copy with updated fields
  JournalEntryModel copyWith({
    int? id,
    String? title,
    String? content,
    DateTime? date,
    Mood? mood,
    String? tags,
    String? voiceNotePath,
    bool? hasVoiceNote,
    int? wordCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return JournalEntryModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      date: date ?? this.date,
      mood: mood ?? this.mood,
      tags: tags ?? this.tags,
      voiceNotePath: voiceNotePath ?? this.voiceNotePath,
      hasVoiceNote: hasVoiceNote ?? this.hasVoiceNote,
      wordCount: wordCount ?? this.wordCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

// Keep old class name for backward compatibility
typedef JournalEntry = JournalEntryModel;
