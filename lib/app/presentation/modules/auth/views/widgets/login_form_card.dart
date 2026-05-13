import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import 'package:visionsafe/app/presentation/global_widgets/atoms/v_button.dart';
import 'package:visionsafe/app/presentation/global_widgets/atoms/v_input.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/auth/auth_divider.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/auth/auth_social_section.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';

/// Kartu form login (Hero Quest Style).
import 'dart:ui';

class LoginFormCard extends GetView<AuthController> {
  const LoginFormCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(48),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(180), // Glassmorphism Effect
            borderRadius: BorderRadius.circular(48),
            border: Border.all(color: const Color(0xFF003366), width: 3), // Bold Retro Border
            boxShadow: [
              BoxShadow(color: Colors.black.withAlpha(20), blurRadius: 20, offset: const Offset(0, 10))
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeading(),
              const SizedBox(height: 24),
              VInput(
                hint: "Username/Email",
                prefixIcon: Icons.person_outline_rounded,
                controller: controller.emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),
              VInput(
                hint: "Password",
                prefixIcon: Icons.lock_outline_rounded,
                isPassword: true,
                controller: controller.passwordController,
              ),
              _buildForgotPassword(),
              const SizedBox(height: 24),
              Obx(() => VButton(
                label: "LET'S GO!",
                icon: Icons.bolt_rounded,
                isLoading: controller.isLoading.value,
                onPressed: () => controller.login(),
              )),
              const SizedBox(height: 20),
              const AuthDivider(),
              const SizedBox(height: 20),
              AuthSocialSection(
                onGoogleTap: () => controller.loginWithGoogle(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeading() {
    return Column(
      children: [
        Text(
          "Welcome Back, Hero!",
          textAlign: TextAlign.center,
          style: AppTextStyles.heading1.copyWith(
            color: const Color(0xFF003366),
            fontSize: 24,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "Log in to keep your eyes safe.",
          style: AppTextStyles.caption.copyWith(
            color: const Color(0xFF003366).withAlpha(180), 
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildForgotPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(top: 12),
        child: GestureDetector(
          onTap: () {},
          child: const Text(
            "Forgot Password?",
            style: TextStyle(
              color: Color(0xFF0056B3),
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
