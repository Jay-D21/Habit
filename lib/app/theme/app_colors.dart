import 'package:flutter/material.dart';

/// Google Material Design 3 inspired color palette
/// Clean, modern colors with pure white/black themes
class AppColors {
  AppColors._();

  // Primary Colors (Google Blue)
  static const Color primary = Color(0xFF1A73E8); // Google Blue
  static const Color primaryLight = Color(0xFF4285F4); // Light Blue
  static const Color primaryDark = Color(0xFF1557B0); // Dark Blue
  static const Color primaryContainer = Color(0xFFD3E3FD); // Light container

  // Secondary Colors (Google Green)
  static const Color secondary = Color(0xFF34A853); // Google Green
  static const Color secondaryLight = Color(0xFF5BB974);
  static const Color secondaryContainer = Color(0xFFCEEAD6);

  // Tertiary Colors (Google Yellow)
  static const Color tertiary = Color(0xFFFBBC04); // Google Yellow
  static const Color tertiaryLight = Color(0xFFFDD663);
  static const Color tertiaryContainer = Color(0xFFFEF7E0);

  // Accent/Orange
  static const Color accent = Color(0xFFFF5722); // Deep Orange
  static const Color accentLight = Color(0xFFFF8A65);

  // Success Colors
  static const Color success = Color(0xFF34A853); // Google Green
  static const Color successLight = Color(0xFF81C995);
  static const Color successContainer = Color(0xFFCEEAD6);

  // Warning Colors
  static const Color warning = Color(0xFFFBBC04); // Google Yellow
  static const Color warningLight = Color(0xFFFDD663);
  static const Color warningContainer = Color(0xFFFEF7E0);

  // Error Colors (Google Red)
  static const Color error = Color(0xFFEA4335); // Google Red
  static const Color errorLight = Color(0xFFF28B82);
  static const Color errorContainer = Color(0xFFFCE8E6);

  // Light Theme Colors (Pure White)
  static const Color backgroundLight = Color(0xFFFFFFFF); // Pure White
  static const Color surfaceLight = Color(0xFFF8F9FA); // Google Gray 100
  static const Color cardLight = Color(0xFFFFFFFF); // Pure White
  static const Color textPrimaryLight = Color(0xFF202124); // Google Gray 900
  static const Color textSecondaryLight = Color(0xFF5F6368); // Google Gray 700
  static const Color borderLight = Color(0xFFDADCE0); // Google Gray 300

  // Dark Theme Colors (Pure Black/Dark)
  static const Color backgroundDark = Color(0xFF121212); // Material Dark
  static const Color surfaceDark = Color(0xFF1E1E1E); // Elevated surface
  static const Color cardDark = Color(0xFF2D2D2D); // Card surface
  static const Color textPrimaryDark = Color(0xFFE8EAED); // Google Gray 200
  static const Color textSecondaryDark = Color(0xFF9AA0A6); // Google Gray 500
  static const Color borderDark = Color(0xFF3C4043); // Google Gray 800

  // Mood Colors
  static const Color moodHappy = Color(0xFF34A853); // Green
  static const Color moodNeutral = Color(0xFF5F6368); // Gray
  static const Color moodSad = Color(0xFF4285F4); // Blue
  static const Color moodAngry = Color(0xFFEA4335); // Red
  static const Color moodCalm = Color(0xFF9334E6); // Purple

  // Category Colors (Google-inspired)
  static const List<Color> categoryColors = [
    Color(0xFF1A73E8), // Blue - Health
    Color(0xFF9334E6), // Purple - Mindfulness
    Color(0xFFFF5722), // Orange - Fitness
    Color(0xFF4285F4), // Light Blue - Learning
    Color(0xFF34A853), // Green - Productivity
    Color(0xFFE91E63), // Pink - Creativity
    Color(0xFFFBBC04), // Yellow - Finance
    Color(0xFF673AB7), // Deep Purple - Personal
  ];

  // Gradient for backgrounds
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF1A73E8),
      Color(0xFF4285F4),
    ],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFF5722),
      Color(0xFFFF8A65),
    ],
  );

  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF34A853),
      Color(0xFF81C995),
    ],
  );
}
