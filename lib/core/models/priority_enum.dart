import 'package:flutter/material.dart';

/// Defines the priority level of a habit.
/// Higher priority = more visual emphasis and higher XP rewards.
enum HabitPriority {
  minimal(1, 'Minimal', 0.5, Color(0xFF9E9E9E)), // Grey
  low(2, 'Low', 1.0, Color(0xFF2196F3)), // Blue
  medium(3, 'Medium', 1.5, Color(0xFF4CAF50)), // Green
  high(4, 'High', 2.0, Color(0xFFFF9800)), // Orange
  critical(5, 'Critical', 2.5, Color(0xFFE53935)); // Red

  final int value;
  final String label;
  final double xpMultiplier;
  final Color color;

  const HabitPriority(this.value, this.label, this.xpMultiplier, this.color);

  /// Get priority from integer value (defaults to medium if invalid)
  static HabitPriority fromValue(int value) {
    return HabitPriority.values.firstWhere(
      (e) => e.value == value,
      orElse: () => HabitPriority.medium,
    );
  }
}
