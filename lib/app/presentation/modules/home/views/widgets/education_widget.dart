import 'package:flutter/material.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';
import 'package:visionsafe/app/presentation/global_widgets/atoms/v_card.dart';

class EducationWidget extends StatelessWidget {
  const EducationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return VCard(
      color: AppColors.secondary,
      child: Row(
        children: [
          const Icon(Icons.lightbulb_outline_rounded, color: Colors.white, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "TAHUKAH KAMU?",
                  style: AppTextStyles.bodyBold.copyWith(color: Colors.white, fontSize: 14),
                ),
                Text(
                  "Jarak aman layar HP adalah 30-40 cm. Itu seperti panjang satu penggaris lho!",
                  style: AppTextStyles.caption.copyWith(color: Colors.white, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
