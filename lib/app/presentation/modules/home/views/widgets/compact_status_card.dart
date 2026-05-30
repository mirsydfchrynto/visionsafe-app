import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_design.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';
import 'package:visionsafe/app/presentation/modules/home/controllers/home_controller.dart';

/// CompactStatusCard: Elite status indicator with interactive glass feedback.
class CompactStatusCard extends StatelessWidget {
  const CompactStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Obx(() {
      final bool isRunning = controller.isServiceRunning;
      final Color baseColor = isRunning ? AppColors.secondary : Colors.white;
      final Color contentColor = isRunning ? Colors.white : AppColors.primaryDark;

      return AnimatedContainer(
        duration: AppDesign.medium,
        curve: AppDesign.smoothCurve,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDesign.radiusM),
          boxShadow: AppDesign.premiumShadow,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppDesign.radiusM),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              padding: const EdgeInsets.all(AppDesign.space16),
              decoration: BoxDecoration(
                color: baseColor.withValues(alpha: isRunning ? 0.95 : 0.8),
                borderRadius: BorderRadius.circular(AppDesign.radiusM),
                border: Border.all(
                  color: isRunning ? Colors.white.withValues(alpha: 0.3) : AppColors.primaryDark.withValues(alpha: 0.1),
                  width: 1.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: contentColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isRunning ? Icons.verified_user_rounded : Icons.shield_outlined,
                      size: 24,
                      color: contentColor,
                    ),
                  ),
                  const SizedBox(height: AppDesign.space16),
                  Text(
                    isRunning ? "VIZO ACTIVE" : "ON BREAK",
                    style: AppTextStyles.bodyBold.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      color: contentColor,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: AppDesign.space2),
                  Text(
                    "Protection Status",
                    style: AppTextStyles.caption.copyWith(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: contentColor.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
