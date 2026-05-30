import 'package:flutter/material.dart';

/// AppDesign: Centralized Design Tokens for VisionSafe AAA Experience.
/// Standardizes spacing, radius, shadows, and buttery-smooth animation curves.
class AppDesign {
  // Spacing System (AAA Standard - Incremental 4/8)
  static const double space2 = 2.0;
  static const double space4 = 4.0;
  static const double space8 = 8.0;
  static const double space12 = 12.0;
  static const double space16 = 16.0;
  static const double space20 = 20.0;
  static const double space24 = 24.0;
  static const double space32 = 32.0;
  static const double space40 = 40.0;
  static const double space48 = 48.0;
  static const double space64 = 64.0;

  // Legacy Mapping (Atomic Scale)
  static const double spaceXS = space4;
  static const double spaceS = space8;
  static const double spaceM = space16;
  static const double spaceL = space24;
  static const double spaceXL = space32;
  static const double spaceXXL = space48;

  // Radius Scale (Smooth & Modern)
  static const double radiusS = 12.0;
  static const double radiusM = 20.0;
  static const double radiusL = 32.0;
  static const double radiusXL = 44.0;
  static const double radiusFull = 100.0;

  // Neobrutalist Parameters
  static const double borderWidth = 2.5;
  static const double shadowOffset = 6.0;
  static const double shadowOffsetSmall = 3.0;
  
  // Premium Shadows
  static List<BoxShadow> get premiumShadow => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.08),
      blurRadius: 24,
      offset: const Offset(0, 12),
    ),
  ];

  static List<BoxShadow> get neoShadow => [
    const BoxShadow(
      color: Color(0xFF1A1A1A),
      offset: Offset(shadowOffset, shadowOffset),
    ),
  ];

  // Padding presets
  static const EdgeInsets screenPadding = EdgeInsets.symmetric(horizontal: spaceL, vertical: spaceM);
  static const EdgeInsets cardPadding = EdgeInsets.all(spaceM);

  // Animations & Transitions
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration medium = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 800);
  static const Duration entrance = Duration(milliseconds: 600);
  
  // AAA Animation Curves
  static const Curve springCurve = Curves.easeOutBack;
  static const Curve smoothCurve = Curves.easeInOutCubic;
  static const Curve elasticCurve = Curves.elasticOut;

  // Layout Helpers
  static double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;
  static double screenHeight(BuildContext context) => MediaQuery.of(context).size.height;
  static bool isSmallScreen(BuildContext context) => screenHeight(context) < 700;
  static bool isTablet(BuildContext context) => screenWidth(context) > 600;
}
