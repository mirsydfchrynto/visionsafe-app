import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visionsafe/app/presentation/modules/home/controllers/home_controller.dart';
import 'package:visionsafe/app/presentation/global_widgets/atoms/v_card.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';

class ProtectionStatusCard extends GetView<HomeController> {
  const ProtectionStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => VCard(
      color: controller.isServiceRunning.value ? AppColors.accent : Colors.white,
      child: Row(
        children: [
          Icon(
            controller.isServiceRunning.value ? Icons.shield : Icons.shield_outlined,
            size: 40,
            color: controller.isServiceRunning.value ? Colors.white : AppColors.charcoal,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.isServiceRunning.value ? "VIZO SEDANG MENJAGA" : "VIZO SEDANG ISTIRAHAT",
                  style: AppTextStyles.bodyBold.copyWith(
                    color: controller.isServiceRunning.value ? Colors.white : AppColors.charcoal,
                  ),
                ),
                Text(
                  controller.isServiceRunning.value ? "Matamu aman bersama Vizo!" : "Aktifkan untuk mulai menjaga.",
                  style: AppTextStyles.caption.copyWith(
                    color: controller.isServiceRunning.value ? Colors.white70 : AppColors.charcoal.withAlpha(150),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
