import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/stats_controller.dart';
import 'widgets/health_score_card.dart';
import 'widgets/screen_time_vs_rest_card.dart';
import 'widgets/violation_heatmap.dart';
import 'widgets/stat_metrics_grid.dart';
import 'widgets/weekly_chart.dart';
import 'widgets/sticker_collection.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';
import 'package:visionsafe/app/presentation/global_widgets/atoms/v_card.dart';

class StatsView extends GetView<StatsController> {
  const StatsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('LAPORAN KESEHATAN', style: AppTextStyles.heading2.copyWith(letterSpacing: 2)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 140),
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
            _buildSectionTitle("ANALISA JAM RAWAN"),
            const ViolationHeatmap(),
            const SizedBox(height: 24),
            _buildInsightCard(),
            const SizedBox(height: 32),
            const StickerCollection(),
            const SizedBox(height: 40),
          ],
        ),
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
          color: AppColors.charcoal.withAlpha(150),
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildInsightCard() {
    return VCard(
      color: AppColors.primary.withAlpha(20),
      child: Row(
        children: [
          const Icon(Icons.analytics_rounded, color: AppColors.primary, size: 36),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("AI INSIGHT", style: AppTextStyles.bodyBold.copyWith(color: AppColors.primary, fontSize: 13)),
                const SizedBox(height: 4),
                Text(
                  "Bagus! Jarak pandangmu stabil di 38cm. Tingkatkan waktu istirahat di sore hari.",
                  style: AppTextStyles.caption.copyWith(height: 1.4, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
