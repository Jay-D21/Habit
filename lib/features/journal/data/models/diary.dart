import 'package:flutter/material.dart';

/// Diary model wrapper
class Diary {
  final int id;
  final String name;
  final String? description;
  final int color; // Color value
  final int iconCodePoint;
  final DateTime createdAt;

  const Diary({
    required this.id,
    required this.name,
    this.description,
    required this.color,
    required this.iconCodePoint,
    required this.createdAt,
  });

  /// Helper to get Color object
  Color get colorObj => Color(color);

  /// Helper to get IconData
  IconData get icon => IconData(iconCodePoint, fontFamily: 'MaterialIcons');

  /// Copy with
  Diary copyWith({
    int? id,
    String? name,
    String? description,
    int? color,
    int? iconCodePoint,
    DateTime? createdAt,
  }) {
    return Diary(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      color: color ?? this.color,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
