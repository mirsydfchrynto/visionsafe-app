import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_design.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';
import 'package:visionsafe/app/presentation/modules/home/controllers/home_controller.dart';

/// CompactActionButton: AAA interactive control button with tactile neobrutalist animations.
class CompactActionButton extends StatelessWidget {
  const CompactActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Obx(() {
      final bool isRunning = controller.isServiceRunning;
      final Color btnBgColor = isRunning ? AppColors.danger : AppColors.success;
      final Color contentColor = isRunning ? Colors.white : AppColors.primaryDark;

      return GestureDetector(
        onTap: () {
          HapticFeedback.heavyImpact();
          controller.toggleService();
        },
        child: AnimatedContainer(
          duration: AppDesign.medium,
          curve: AppDesign.springCurve,
          padding: const EdgeInsets.all(AppDesign.space16),
          decoration: BoxDecoration(
            color: btnBgColor,
            borderRadius: BorderRadius.circular(AppDesign.radiusM),
            border: Border.all(color: AppColors.primaryDark, width: 2.5),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryDark, 
                offset: isRunning 
                  ? const Offset(2, 2) 
                  : const Offset(6, 6)
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isRunning ? Icons.stop_rounded : Icons.play_arrow_rounded,
                  size: 24,
                  color: contentColor,
                ),
              ),
              const SizedBox(height: AppDesign.space16),
              Text(
                isRunning ? "STOP VIZO" : "START VIZO",
                style: AppTextStyles.bodyBold.copyWith(
                  fontSize: 13, 
                  fontWeight: FontWeight.w900,
                  color: contentColor,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: AppDesign.space2),
              Text(
                "Main Control",
                style: AppTextStyles.caption.copyWith(
                  fontSize: 9, 
                  fontWeight: FontWeight.w700,
                  color: contentColor.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
