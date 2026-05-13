import 'package:flutter/material.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';
import 'package:visionsafe/app/presentation/global_widgets/atoms/v_card.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/vizo_mascot.dart';

/// Kartu salam dengan animasi maskot (Unified Visual Identity).
/// Menggunakan VizoMascot Network Lottie yang ekspresif.
class VizoGreetingCard extends StatelessWidget {
  const VizoGreetingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return VCard(
      color: const Color(0xFFE0EAFC),
      padding: 24,
      child: Row(
        children: [
          // Mascot diperbesar dan konsisten dengan Login/Register
          const VizoMascot(size: 80), 
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "HALO PAHLAWAN!",
                  style: AppTextStyles.heading2.copyWith(
                    color: const Color(0xFF003366), 
                    fontSize: 20,
                    fontWeight: FontWeight.w900
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Vizo siap menjagamu hari ini. Jangan lupa kedipkan mata ya!",
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.charcoal.withAlpha(180),
                    fontSize: 12
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
