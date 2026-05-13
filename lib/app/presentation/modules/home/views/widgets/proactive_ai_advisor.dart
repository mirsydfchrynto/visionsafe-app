import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';
import 'package:visionsafe/app/presentation/global_widgets/atoms/v_card.dart';
import '../../controllers/home_controller.dart';

class ProactiveAiAdvisor extends GetView<HomeController> {
  const ProactiveAiAdvisor({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isViolation = controller.telemetryService.isViolation.value;
      final distance = controller.telemetryService.currentDistance.value;
      
      String title = "SARAN VIZO";
      String message = "Semuanya terlihat baik! Pertahankan jarakmu.";
      IconData icon = Icons.check_circle_outline_rounded;
      Color color = AppColors.success;

      if (isViolation) {
        title = "PERINGATAN!";
        message = "Kamu terlalu dekat! Mundurkan kepalamu sedikit.";
        icon = Icons.warning_rounded;
        color = AppColors.danger;
      } else if (distance < controller.telemetryService.currentDistance.value + 5) {
        title = "HATI-HATI";
        message = "Hampir terlalu dekat. Tetap waspada ya!";
        icon = Icons.info_outline_rounded;
        color = Colors.orange;
      }

      return AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        child: VCard(
          color: color.withAlpha(15),
          border: Border.all(color: color, width: 2),
          child: Row(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.bodyBold.copyWith(color: color, fontSize: 13)),
                    const SizedBox(height: 2),
                    Text(message, style: AppTextStyles.caption.copyWith(fontSize: 11)),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
