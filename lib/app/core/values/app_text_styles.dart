import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Tipografi kustom untuk VisionSafe menggunakan Google Fonts.
/// File: app_text_styles.dart (< 100 lines)
class AppTextStyles {
  static TextStyle heading1 = GoogleFonts.outfit(
    fontSize: 28,
    fontWeight: FontWeight.w900,
    color: AppColors.charcoal,
    letterSpacing: -0.5,
  );

  static TextStyle heading2 = GoogleFonts.outfit(
    fontSize: 22,
    fontWeight: FontWeight.w800,
    color: AppColors.charcoal,
  );

  static TextStyle bodyBold = GoogleFonts.plusJakartaSans(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.charcoal,
  );

  static TextStyle bodyMedium = GoogleFonts.plusJakartaSans(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.charcoal,
  );

  static TextStyle caption = GoogleFonts.plusJakartaSans(
    fontSize: 12,
    color: AppColors.grey,
    fontWeight: FontWeight.w600,
  );
}
