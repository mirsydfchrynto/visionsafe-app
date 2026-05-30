import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visionsafe/app/presentation/modules/stats/controllers/stats_controller.dart';
import 'package:visionsafe/app/presentation/global_widgets/atoms/v_card.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';

class WeeklyChart extends GetView<StatsController> {
  const WeeklyChart({super.key});

  @override
  Widget build(BuildContext context) {
    return VCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("PROGRESS MINGGUAN", style: AppTextStyles.bodyBold.copyWith(fontSize: 14)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: AppColors.success.withAlpha(40), borderRadius: BorderRadius.circular(8)),
                child: Text("+12% STABIL", style: AppTextStyles.caption.copyWith(color: AppColors.success, fontWeight: FontWeight.bold, fontSize: 8)),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 180,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildBar("SEN", 0.4, AppColors.primary),
                _buildBar("SEL", 0.7, AppColors.success),
                _buildBar("RAB", 0.9, AppColors.danger),
                _buildBar("KAM", 0.5, AppColors.primary),
                _buildBar("JUM", 0.8, AppColors.secondary),

                _buildBar("SAB", 0.6, Colors.orange),
                _buildBar("MIN", 0.3, AppColors.success),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBar(String label, double percent, Color color) {
    return Column(
      children: [
        Expanded(
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                width: 12,
                decoration: BoxDecoration(
                  color: color.withAlpha(20),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              FractionallySizedBox(
                heightFactor: percent,
                child: Container(
                  width: 12,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.charcoal, width: 2),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          label, 
          style: AppTextStyles.caption.copyWith(
            fontSize: 8, 
            fontWeight: FontWeight.w900,
            color: AppColors.charcoal.withAlpha(150),
          ),
        ),
      ],
    );
  }
}
