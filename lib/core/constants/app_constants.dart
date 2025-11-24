import 'package:flutter/material.dart';

/// App-wide constants for consistent styling and configuration
class AppConstants {
  // Spacing constants
  static const double spacing4 = 4.0;
  static const double spacing8 = 8.0;
  static const double spacing12 = 12.0;
  static const double spacing16 = 16.0;
  static const double spacing20 = 20.0;
  static const double spacing24 = 24.0;
  static const double spacing32 = 32.0;
  static const double spacing48 = 48.0;

  // Border radius constants
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 24.0;
  static const double radiusCircle = 100.0;

  // Icon sizes
  static const double iconSmall = 16.0;
  static const double iconMedium = 20.0;
  static const double iconLarge = 24.0;
  static const double iconXLarge = 48.0;
  static const double iconXXLarge = 80.0;

  // Button heights
  static const double buttonHeight = 56.0;
  static const double buttonHeightSmall = 48.0;

  // Border widths
  static const double borderThin = 1.0;
  static const double borderMedium = 1.5;
  static const double borderThick = 2.0;

  // Animation durations
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Session settings
  static const Duration sessionTimerInterval = Duration(seconds: 1);
  static const Duration mockPaymentInterval = Duration(seconds: 10);
  static const double sessionFeePercentage = 0.013; // 1.3%

  // Timeouts
  static const Duration networkTimeout = Duration(seconds: 30);
  static const Duration shortDelay = Duration(milliseconds: 300);
  static const Duration mediumDelay = Duration(milliseconds: 800);
  static const Duration longDelay = Duration(milliseconds: 1200);

  // Search & input
  static const int searchDebounceMs = 300;
  static const int minPasswordLength = 8;
  static const int maxSessionNoteLength = 500;

  // Edge insets
  static const EdgeInsets paddingAll8 = EdgeInsets.all(8.0);
  static const EdgeInsets paddingAll12 = EdgeInsets.all(12.0);
  static const EdgeInsets paddingAll16 = EdgeInsets.all(16.0);
  static const EdgeInsets paddingAll20 = EdgeInsets.all(20.0);
  static const EdgeInsets paddingAll24 = EdgeInsets.all(24.0);
  static const EdgeInsets paddingAll32 = EdgeInsets.all(32.0);

  static const EdgeInsets paddingH16 = EdgeInsets.symmetric(horizontal: 16.0);
  static const EdgeInsets paddingH24 = EdgeInsets.symmetric(horizontal: 24.0);
  static const EdgeInsets paddingV8 = EdgeInsets.symmetric(vertical: 8.0);
  static const EdgeInsets paddingV12 = EdgeInsets.symmetric(vertical: 12.0);
  static const EdgeInsets paddingV16 = EdgeInsets.symmetric(vertical: 16.0);

  static const EdgeInsets paddingH16V12 = EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0);
  static const EdgeInsets paddingH24V16 = EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0);
  static const EdgeInsets paddingH16V8 = EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0);
  static const EdgeInsets paddingAll48 = EdgeInsets.all(48.0);

  // Border radius objects
  static const BorderRadius borderRadiusSmall = BorderRadius.all(Radius.circular(radiusSmall));
  static const BorderRadius borderRadiusMedium = BorderRadius.all(Radius.circular(radiusMedium));
  static const BorderRadius borderRadiusLarge = BorderRadius.all(Radius.circular(radiusLarge));
  static const BorderRadius borderRadiusXLarge = BorderRadius.all(Radius.circular(radiusXLarge));

  // Prevent instantiation
  const AppConstants._();
}
