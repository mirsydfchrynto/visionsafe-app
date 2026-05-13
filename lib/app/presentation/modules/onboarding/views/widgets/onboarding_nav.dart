import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visionsafe/app/presentation/modules/onboarding/controllers/onboarding_controller.dart';
import 'package:visionsafe/app/presentation/global_widgets/atoms/v_button.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';

class OnboardingNav extends GetView<OnboardingController> {
  const OnboardingNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        children: [
          _buildDots(),
          const SizedBox(height: 32),
          Obx(() => VButton(
                label: controller.isLastPage ? "AYO MULAI!" : "LANJUT",
                onPressed: controller.nextPage,
              )),
        ],
      ),
    );
  }

  Widget _buildDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        controller.pages.length,
        (index) => Obx(() => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 12,
              width: controller.currentPage.value == index ? 24 : 12,
              decoration: BoxDecoration(
                color: controller.currentPage.value == index
                    ? AppColors.primary
                    : AppColors.charcoal.withAlpha(50),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppColors.charcoal, width: 2),
              ),
            )),
      ),
    );
  }
}
