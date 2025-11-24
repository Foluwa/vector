import 'package:flutter/material.dart';

/// Design system colors for Vector app
class AppColors {
  AppColors._();

  // Primary brand color - Vector Green
  static const Color primary = Color(0xFF01FF42);
  static const Color primaryDark = Color(0xFF00CC35);
  static const Color primaryLight = Color(0xFF66FF8C);

  // Neutral colors
  static const Color textPrimary = Color(0xFF000000);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textTertiary = Color(0xFF999999);

  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF5F5F5);
  static const Color surfaceVariant = Color(0xFFEEEEEE);

  // Status colors
  static const Color success = Color(0xFF01FF42);
  static const Color error = Color(0xFFFF3B30);
  static const Color warning = Color(0xFFFF9500);
  static const Color info = Color(0xFF007AFF);

  // Transaction colors
  static const Color positiveAmount = Color(0xFF01FF42);
  static const Color negativeAmount = Color(0xFF000000);

  // UI element colors
  static const Color border = Color(0xFFE0E0E0);
  static const Color divider = Color(0xFFEEEEEE);
  static const Color skeleton = Color(0xFFE0E0E0);

  // Status indicator
  static const Color statusActive = Color(0xFF01FF42);
  static const Color statusExpired = Color(0xFFFF9500);
  static const Color statusInactive = Color(0xFF999999);

  // Overlay
  static const Color overlay = Color(0x66000000);
  static const Color overlayLight = Color(0x33000000);
}
