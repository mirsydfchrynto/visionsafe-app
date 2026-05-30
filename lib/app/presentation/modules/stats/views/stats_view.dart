import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/stats_controller.dart';
import 'widgets/health_score_card.dart';
import 'widgets/screen_time_vs_rest_card.dart';
import 'widgets/violation_heatmap.dart';
import 'widgets/stat_metrics_grid.dart';
import 'widgets/weekly_chart.dart';
import 'widgets/leaderboard_widget.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';
import 'package:visionsafe/app/presentation/global_widgets/atoms/v_card.dart';
import 'package:visionsafe/app/presentation/global_widgets/templates/base_screen_template.dart';

import 'package:visionsafe/app/presentation/global_widgets/molecules/v_app_header.dart';

class StatsView extends GetView<StatsController> {
  const StatsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreenTemplate(
      appBar: const VAppHeader(title: 'LAPORAN KESEHATAN'),
      bottomPadding: 180,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HealthScoreCard(),
          const SizedBox(height: 24),
          _buildSectionTitle("RINGKASAN METRIK"),
          const StatMetricsGrid(),
          const SizedBox(height: 24),
          _buildSectionTitle("PROGRESS MINGGUAN"),
          const WeeklyChart(),
          const SizedBox(height: 24),
          _buildSectionTitle("KESEIMBANGAN WAKTU"),
          const ScreenTimeVsRestCard(),
          const SizedBox(height: 24),
          _buildSectionTitle("GLOBAL RANKING"),
          const LeaderboardWidget(),
          const SizedBox(height: 24),
          _buildSectionTitle("ANALISA JAM RAWAN"),
          const ViolationHeatmap(),
          const SizedBox(height: 24),
          _buildInsightCard(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }


  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title,
        style: AppTextStyles.bodyBold.copyWith(
          fontSize: 11,
          color: AppColors.primaryDark.withAlpha(150),
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildInsightCard() {
    return VCard(
      color: Colors.white,
      border: Border.all(color: AppColors.secondary, width: 3),
      boxShadow: [
        BoxShadow(
          color: AppColors.secondary.withAlpha(80),
          offset: const Offset(6, 6),
        ),
      ],
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.secondary.withAlpha(20),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.auto_awesome_rounded, color: AppColors.secondary, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "AI INSIGHT", 
                  style: AppTextStyles.bodyBold.copyWith(
                    color: AppColors.secondary, 
                    fontSize: 13,
                    letterSpacing: 1.0,
                  )
                ),
                const SizedBox(height: 4),
                Text(
                  "Bagus! Jarak pandangmu stabil di 38cm. Tingkatkan waktu istirahat di sore hari.",
                  style: AppTextStyles.caption.copyWith(
                    height: 1.5, 
                    fontSize: 11, 
                    color: AppColors.primaryDark.withAlpha(200),
                    fontWeight: FontWeight.w600,
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
