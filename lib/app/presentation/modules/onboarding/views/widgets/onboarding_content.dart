import 'package:flutter/material.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/vizo_mascot.dart';

/// OnboardingContent: Menampilkan Visual Hero tunggal yang kreatif.
class OnboardingContent extends StatelessWidget {
  final Map<String, dynamic> page;

  const OnboardingContent({super.key, required this.page});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildHeroStage(),
          const SizedBox(height: 60),
          Text(
            (page['title'] ?? '').toUpperCase(),
            textAlign: TextAlign.center,
            style: AppTextStyles.heading1.copyWith(
              fontSize: 32,
              color: AppColors.primaryDark,
              height: 1.1,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            page['desc'] ?? '',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.primaryDark.withAlpha(180),
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroStage() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Background Decorative Grid/Circle
        Container(
          height: 300,
          width: 300,
          decoration: BoxDecoration(
            color: AppColors.primary.withAlpha(20),
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primaryDark.withAlpha(30), width: 3),
          ),
        ),
        
        // Floating Platform
        Positioned(
          bottom: 40,
          child: Container(
            height: 24,
            width: 180,
            decoration: BoxDecoration(
              color: AppColors.primaryDark.withAlpha(40),
              borderRadius: const BorderRadius.all(Radius.elliptical(180, 24)),
            ),
          ),
        ),

        // Single Creative Mascot
        VizoMascot(
          size: 240, 
          state: page['state'] ?? VizoState.idle,
        ),
        
        // Floating Decorative Elements
        Positioned(
          top: 40,
          right: 30,
          child: _buildFloatingIcon(Icons.bolt_rounded, AppColors.warning),
        ),
        Positioned(
          bottom: 100,
          left: 20,
          child: _buildFloatingIcon(Icons.shield_outlined, AppColors.success),
        ),
      ],
    );
  }

  Widget _buildFloatingIcon(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.primaryDark, width: 3),
        boxShadow: const [BoxShadow(color: AppColors.primaryDark, offset: Offset(4, 4))],
      ),
      child: Icon(icon, color: color, size: 28),
    );
  }
}
