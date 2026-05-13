import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visionsafe/app/presentation/modules/home/controllers/home_controller.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';

/// Menampilkan total durasi pelanggaran hari ini.
class DailyAnalyticsCard extends GetView<HomeController> {
  const DailyAnalyticsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final minutes = controller.dailyViolationMinutes.value;
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.charcoal, width: 2),
          boxShadow: const [BoxShadow(color: AppColors.charcoal, offset: Offset(4, 4))],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildInfo(minutes),
            _buildIcon(minutes),
          ],
        ),
      );
    });
  }

  Widget _buildInfo(double minutes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Total Pelanggaran Jarak",
          style: AppTextStyles.caption.copyWith(color: AppColors.grey),
        ),
        Text(
          "${minutes.toStringAsFixed(2)} Menit",
          style: AppTextStyles.heading2,
        ),
      ],
    );
  }

  Widget _buildIcon(double minutes) {
    return Icon(
      Icons.query_stats_rounded,
      color: minutes > 5 ? AppColors.danger : AppColors.primary,
      size: 40,
    );
  }
}
