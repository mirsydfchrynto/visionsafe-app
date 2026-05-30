import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';
import 'package:visionsafe/app/presentation/global_widgets/atoms/v_card.dart';
import '../../controllers/stats_controller.dart';

class ViolationHeatmap extends GetView<StatsController> {
  const ViolationHeatmap({super.key});

  @override
  Widget build(BuildContext context) {
    return VCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("JAM RAWAN PELANGGARAN", style: AppTextStyles.bodyBold.copyWith(fontSize: 14)),
              const Icon(Icons.history_toggle_off_rounded, color: AppColors.charcoal, size: 18),
            ],
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              // Menghitung ukuran box secara dinamis agar tidak overflow
              final double itemWidth = (constraints.maxWidth - (5 * 6)) / 6; 
              
              return Wrap(
                spacing: 6,
                runSpacing: 6,
                children: List.generate(24, (index) {
                  final double intensity = controller.hourlyViolations[index];
                  return _buildHeatBox(index, intensity, itemWidth);
                }),
              );
            },
          ),
          const SizedBox(height: 16),
          _buildLegend(),
        ],
      ),
    );
  }

  Widget _buildHeatBox(int hour, double intensity, double size) {
    Color boxColor = AppColors.success.withAlpha((40 + (intensity * 215)).toInt());
    if (intensity > 0.7) {
      boxColor = AppColors.danger.withAlpha((intensity * 255).toInt());
    } else if (intensity > 0.3) {
      boxColor = Colors.orange.withAlpha((intensity * 255).toInt());
    }

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center, // Strict centering
      decoration: BoxDecoration(
        color: boxColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.charcoal.withAlpha(30), width: 1),
      ),
      child: Text(
        "$hour",
        style: AppTextStyles.caption.copyWith(
          fontSize: 9,
          fontWeight: FontWeight.w900,
          color: intensity > 0.5 ? Colors.white : AppColors.charcoal.withAlpha(150),
          height: 1.0, // Prevent line height shift
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Row(
      children: [
        Text("Tingkat Bahaya:", style: AppTextStyles.caption.copyWith(fontSize: 10, fontWeight: FontWeight.bold)),
        const Spacer(),
        _legendItem("Aman", AppColors.success.withAlpha(100)),
        const SizedBox(width: 8),
        _legendItem("Waspada", Colors.orange.withAlpha(150)),
        const SizedBox(width: 8),
        _legendItem("Bahaya", AppColors.danger.withAlpha(200)),
      ],
    );
  }

  Widget _legendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 8, height: 8,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
        ),
        const SizedBox(width: 4),
        Text(label, style: AppTextStyles.caption.copyWith(fontSize: 9)),
      ],
    );
  }
}
