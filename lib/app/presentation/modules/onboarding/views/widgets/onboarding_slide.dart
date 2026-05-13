import 'package:flutter/material.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';

/// Komponen reusable untuk slide onboarding.
/// File: onboarding_slide.dart (< 100 lines)
class OnboardingSlide extends StatelessWidget {
  final String title;
  final String description;
  final Widget illustration;
  final Color bgColor;

  const OnboardingSlide({
    super.key,
    required this.title,
    required this.description,
    required this.illustration,
    this.bgColor = AppColors.background,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bgColor,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildIllustration(),
          const SizedBox(height: 60),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.heading1,
          ),
          const SizedBox(height: 20),
          Text(
            description,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildIllustration() {
    return Container(
      height: 280,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: AppColors.charcoal, width: 4),
        boxShadow: const [
          BoxShadow(color: AppColors.charcoal, offset: Offset(8, 8)),
        ],
      ),
      child: Center(child: illustration),
    );
  }
}
