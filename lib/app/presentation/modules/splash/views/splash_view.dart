import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visionsafe/app/data/services/auth_service.dart';
import 'package:visionsafe/app/routes/app_pages.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/vizo_mascot.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..forward();
    
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 3));
    
    final authService = Get.find<AuthService>();
    
    if (authService.isLoggedIn.value) {
      Get.offAllNamed(Routes.mainWrapper);
    } else {
      Get.offAllNamed(Routes.onboarding);
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0EAFC),
      body: Center(
        child: FadeTransition(
          opacity: _fadeController,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const VizoMascot(size: 240),
              const SizedBox(height: 40),
              Text(
                "VISIONSAFE",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF003366),
                  letterSpacing: 4,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Your Cyber Health Guardian",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF003366).withAlpha(150),
                ),
              ),
              const SizedBox(height: 80),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF003366)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
