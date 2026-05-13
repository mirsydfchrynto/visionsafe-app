import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import 'package:visionsafe/app/presentation/global_widgets/atoms/v_button.dart';
import 'package:visionsafe/app/presentation/global_widgets/atoms/v_input.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/auth/auth_divider.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/auth/auth_social_section.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';
import 'dart:ui';

/// Kartu form registrasi (Elite Retro-Glass Style).
class RegisterFormCard extends GetView<AuthController> {
  const RegisterFormCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(48),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
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
              const SizedBox(height: 20),
              VInput(
                hint: "Full Name",
                prefixIcon: Icons.badge_outlined,
                controller: controller.nameController,
              ),
              const SizedBox(height: 10),
              VInput(
                hint: "Email Address",
                prefixIcon: Icons.email_outlined,
                controller: controller.emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 10),
              VInput(
                hint: "Password",
                prefixIcon: Icons.lock_outline_rounded,
                isPassword: true,
                controller: controller.passwordController,
              ),
              const SizedBox(height: 10),
              VInput(
                hint: "Confirm Password",
                prefixIcon: Icons.lock_reset_rounded,
                isPassword: true,
                controller: controller.confirmPasswordController,
              ),
              const SizedBox(height: 20),
              Obx(() => VButton(
                label: "CREATE ACCOUNT",
                icon: Icons.person_add_alt_1_rounded,
                isLoading: controller.isLoading.value,
                onPressed: () => controller.register(),
              )),
              const SizedBox(height: 16),
              const AuthDivider(),
              const SizedBox(height: 16),
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
          "Join the Quest!",
          style: AppTextStyles.heading1.copyWith(
            color: const Color(0xFF003366),
            fontSize: 24,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "Create an account to start your journey.",
          textAlign: TextAlign.center,
          style: AppTextStyles.caption.copyWith(
            color: const Color(0xFF003366).withAlpha(180),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
