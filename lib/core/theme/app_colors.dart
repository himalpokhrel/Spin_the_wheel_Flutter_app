import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

  // Light theme
  static const Color background = Color(0xFFF5F0E8);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color card = Color(0xFFFFFFFF);
  static const Color primary = Color(0xFF6C63FF);
  static const Color secondary = Color(0xFFFF6584);
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF666680);
  static const Color divider = Color(0xFFE8E8F0);
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFE53935);

  // Dark theme
  static const Color darkBackground = Color(0xFF0F0F1A);
  static const Color darkSurface = Color(0xFF1C1B2E);
  static const Color darkCard = Color(0xFF252438);
  static const Color darkTextPrimary = Color(0xFFF5F5FF);
  static const Color darkTextSecondary = Color(0xFFB0AEC8);
  static const Color darkDivider = Color(0xFF2E2D45);

  // Wheel slice colors — vibrant set
  static const List<Color> wheelColors = [
    Color(0xFFFF6B6B), // red
    Color(0xFFFF9F43), // orange
    Color(0xFFFFD93D), // yellow
    Color(0xFF6BCB77), // green
    Color(0xFF4ECDC4), // teal
    Color(0xFF45B7D1), // blue
    Color(0xFF9B59B6), // purple
    Color(0xFFFF6584), // pink
  ];
}
