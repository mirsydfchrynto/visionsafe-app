import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/onboarding_controller.dart';
import 'widgets/onboarding_content.dart';
import 'widgets/onboarding_nav.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';

/// OnboardingView: Layar pengenalan untuk anak-anak.
/// Mematuhi aturan Micro-File & Modular UI.
class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                onPageChanged: controller.updatePageIndex,
                itemCount: controller.pages.length,
                itemBuilder: (context, index) {
                  return OnboardingContent(page: controller.pages[index]);
                },
              ),
            ),
            const OnboardingNav(),
          ],
        ),
      ),
    );
  }
}
