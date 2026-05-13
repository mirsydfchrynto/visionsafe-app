import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/vizo_mascot.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/auth/auth_footer_link.dart';
import 'widgets/register_form_card.dart';
import 'package:visionsafe/app/routes/app_pages.dart';

/// Screen Register VisionSafe: Hero Quest Edition (Decomposed).
/// Sesuai Standar SDA V2: Micro-File Mandate (< 100 baris).
class RegisterView extends GetView<AuthController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0EAFC),
      body: Stack(
        children: [
          // 1. Subtle Cyber-Background Pattern
          _buildCyberBackground(),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  
                  // 2. The Living Mascot (Friendly Cyber Eye)
                  const VizoMascot(size: 160),
                  
                  const SizedBox(height: 30),
                  
                  // 3. The Glass-Retro Register Card
                  const RegisterFormCard(),
                  
                  const SizedBox(height: 30),
                  
                  // 4. Elegant Footer
                  _buildFooter(),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCyberBackground() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFE0EAFC), Color(0xFFCFDEF3)],
        ),
      ),
      child: Opacity(
        opacity: 0.03,
        child: CustomPaint(painter: _GridPainter()),
      ),
    );
  }

  Widget _buildFooter() {
    return AuthFooterLink(
      text: "Already a Hero? ",
      linkText: "Back to Quest!",
      onTap: () => Get.offNamed(Routes.login),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFF003366)..strokeWidth = 1;
    for (double i = 0; i < size.width; i += 40) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += 40) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
