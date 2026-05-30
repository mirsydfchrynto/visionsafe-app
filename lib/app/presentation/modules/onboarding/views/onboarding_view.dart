import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/onboarding_controller.dart';
import 'widgets/onboarding_content.dart';
import 'widgets/onboarding_nav.dart';
import 'package:visionsafe/app/core/values/app_design.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/v_immersive_background.dart';

/// OnboardingView: Premium child-friendly introduction.
class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: VImmersiveBackground(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: controller.pageController,
                  physics: const BouncingScrollPhysics(),
                  onPageChanged: controller.updatePageIndex,
                  itemCount: controller.pages.length,
                  itemBuilder: (context, index) {
                    return OnboardingContent(page: controller.pages[index]);
                  },
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppDesign.spaceL),
                child: OnboardingNav(),
              ),
              const SizedBox(height: AppDesign.spaceXL),
            ],
          ),
        ),
      ),
    );
  }
}
