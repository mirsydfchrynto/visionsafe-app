import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:visionsafe/app/presentation/global_widgets/molecules/vizo_mascot.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';

/// Halaman Intervensi (Overlay Blur) saat pelanggaran jarak.
/// File: intervention_view.dart (< 150 lines)
class InterventionView extends StatelessWidget {
  const InterventionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          _buildBlurBackground(),
          _buildInterventionContent(),
        ],
      ),
    );
  }

  Widget _buildBlurBackground() {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
      child: Container(
        color: AppColors.charcoal.withValues(alpha: 0.6),
      ),
    );
  }

  Widget _buildInterventionContent() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildVizoWarning(),
            const SizedBox(height: 32),
            _buildWarningCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildVizoWarning() {
    return const Stack(
      alignment: Alignment.center,
      children: [
        VizoMascot(state: VizoState.intervention),
        Positioned(
          bottom: 0,
          right: 0,
          child: CircleAvatar(
            backgroundColor: AppColors.danger,
            radius: 24,
            child: Icon(Icons.back_hand_rounded, color: Colors.white, size: 28),
          ),
        ),
      ],
    );
  }

  Widget _buildWarningCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: AppColors.charcoal, width: 4),
        boxShadow: const [
          BoxShadow(color: AppColors.charcoal, offset: Offset(8, 8)),
        ],
      ),
      child: Column(
        children: [
          Text(
            "HAYO! TERLALU DEKAT!",
            textAlign: TextAlign.center,
            style: AppTextStyles.heading1.copyWith(color: AppColors.danger),
          ),
          const SizedBox(height: 16),
          Text(
            "Mundurkan HP-mu sejauh lengan\nuntuk membuka kunci layar.",
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: 24),
          const LinearProgressIndicator(
            backgroundColor: AppColors.background,
            color: AppColors.primary,
            minHeight: 8,
          ),
        ],
      ),
    );
  }
}
