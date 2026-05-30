import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/vizo_mascot.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/auth/auth_footer_link.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/v_immersive_background.dart';
import 'widgets/login_form_card.dart';
import 'package:visionsafe/app/routes/app_pages.dart';
import 'package:visionsafe/app/core/values/app_design.dart';

import 'package:visionsafe/app/presentation/global_widgets/animations/fade_in_up.dart';

/// LoginView: World-Class Auth Experience.
/// Features immersive layered background, responsive centering, and AAA animations.
class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0EAFC),
      resizeToAvoidBottomInset: true,
      body: VImmersiveBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isSmall = constraints.maxHeight < 700;
              
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppDesign.spaceL),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: isSmall ? AppDesign.spaceXL : AppDesign.space64),
                        
                        // Hero Mascot with floating animation
                        Hero(
                          tag: 'vizo_mascot',
                          child: VizoMascot(
                            size: isSmall ? 130 : 160,
                            state: VizoState.idle,
                          ),
                        ),
                        
                        SizedBox(height: isSmall ? AppDesign.spaceL : AppDesign.space40),
                        
                        // Elite Form Card
                        const LoginFormCard(),
                        
                        const SizedBox(height: AppDesign.space32),
                        
                        // Modern Footer
                        _buildFooter(),
                        
                        const SizedBox(height: AppDesign.spaceXL),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return FadeInUp(
      delay: const Duration(milliseconds: 800),
      child: AuthFooterLink(
        text: "New here? ",
        linkText: "Join the quest!",
        onTap: () => Get.toNamed(Routes.register),
      ),
    );
  }
}
