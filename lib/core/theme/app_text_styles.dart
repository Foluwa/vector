import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Typography system for Vector app
class AppTextStyles {
  AppTextStyles._();

  // Display styles (large titles)
  static TextStyle display1 = GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.w700, height: 1.2, color: AppColors.textPrimary, letterSpacing: -0.5);

  static TextStyle display2 = GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.w700, height: 1.25, color: AppColors.textPrimary, letterSpacing: -0.5);

  // Heading styles
  static TextStyle h1 = GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w600, height: 1.3, color: AppColors.textPrimary, letterSpacing: -0.3);

  static TextStyle h2 = GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w600, height: 1.3, color: AppColors.textPrimary);

  static TextStyle h3 = GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600, height: 1.3, color: AppColors.textPrimary);

  // Body styles
  static TextStyle body1 = GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w400, height: 1.5, color: AppColors.textPrimary);

  static TextStyle body2 = GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400, height: 1.5, color: AppColors.textPrimary);

  static TextStyle body1Medium = GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500, height: 1.5, color: AppColors.textPrimary);

  static TextStyle body2Medium = GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, height: 1.5, color: AppColors.textPrimary);

  // Caption & small text
  static TextStyle caption = GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w400, height: 1.5, color: AppColors.textSecondary);

  static TextStyle captionMedium = GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, height: 1.5, color: AppColors.textSecondary);

  static TextStyle overline = GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, height: 1.5, color: AppColors.textSecondary, letterSpacing: 0.5);

  // Button text
  static TextStyle button = GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, height: 1.2, color: AppColors.textPrimary);

  static TextStyle buttonSmall = GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, height: 1.2, color: AppColors.textPrimary);

  // Amount styles
  static TextStyle amountLarge = GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.w700, height: 1.2, color: AppColors.textPrimary, letterSpacing: -0.5);

  static TextStyle amountMedium = GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w600, height: 1.2, color: AppColors.textPrimary);

  static TextStyle amountSmall = GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, height: 1.2, color: AppColors.textPrimary);
}
