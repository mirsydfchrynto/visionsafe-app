import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/vizo_mascot.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/auth/auth_footer_link.dart';
import 'widgets/login_form_card.dart';
import 'package:visionsafe/app/routes/app_pages.dart';

/// Screen Login VisionSafe: Hero Quest Edition (Decomposed).
/// Sesuai Standar SDA V2: Micro-File Mandate (< 100 baris).
class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0EAFC),
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          _buildCyberBackground(),

          SafeArea(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: MediaQuery.of(context).size.width,
                  minHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      
                      // 1. The Living Mascot (Cyber Emoticon)
                      const VizoMascot(size: 200),
                      
                      const Spacer(flex: 2), 
                      
                      // 2. The Glass-Retro Auth Card
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 28.0),
                        child: LoginFormCard(),
                      ),
                      
                      const Spacer(flex: 3),
                      
                      // 3. Elegant Footer
                      _buildFooter(),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
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
      text: "New here? ",
      linkText: "Join the quest!",
      onTap: () => Get.toNamed(Routes.register),
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
