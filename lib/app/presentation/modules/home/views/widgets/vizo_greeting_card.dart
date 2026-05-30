import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';
import 'package:visionsafe/app/core/values/app_design.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/vizo_mascot.dart';
import 'package:visionsafe/app/presentation/modules/home/controllers/home_controller.dart';

/// VizoGreetingCard: Premium personalized greeting with immersive glass design.
class VizoGreetingCard extends StatelessWidget {
  const VizoGreetingCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppDesign.radiusL),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(AppDesign.space24),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.75),
            borderRadius: BorderRadius.circular(AppDesign.radiusL),
            border: Border.all(
              color: AppColors.primaryDark.withValues(alpha: 0.1), 
              width: 1.5,
            ),
            boxShadow: AppDesign.premiumShadow,
          ),
          child: Row(
            children: [
              // Interactive Mascot Thumbnail
              Obx(() {
                final profile = controller.userProfile.value;
                final mascotState = VizoMascot.fromMascotState(profile?.mascotState);
                return Hero(
                  tag: 'vizo_thumb',
                  child: VizoMascot(size: 72, state: mascotState),
                );
              }),
              
              const SizedBox(width: AppDesign.space20),
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() {
                      final profile = controller.userProfile.value;
                      final name = profile?.fullName?.split(' ').first.toUpperCase() ?? "HERO";
                      return Text(
                        "HELLO, $name!",
                        style: AppTextStyles.heading2.copyWith(
                          color: AppColors.primaryDark, 
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.0,
                        ),
                      );
                    }),
                    const SizedBox(height: 4),
                    Obx(() {
                      final profile = controller.userProfile.value;
                      final streak = profile?.streakDays ?? 0;
                      return Text(
                        streak > 0 
                          ? "You're on a $streak-day streak! Keep it up, Hero!"
                          : "Vizo is ready to protect your eyes today.",
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.primaryDark.withValues(alpha: 0.6),
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      );
                    }),
                  ],
                ),
              ),
              
              // Achievement Badge Mini
              _buildAchievementBadge(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAchievementBadge() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.15),
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.4), width: 1.5),
      ),
      child: const Icon(Icons.auto_awesome_rounded, color: AppColors.warning, size: 20),
    );
  }
}
