import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import 'package:visionsafe/app/presentation/global_widgets/organisms/live_vizo_radar.dart';
import 'package:visionsafe/app/presentation/global_widgets/organisms/quick_stats_grid.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/eye_care_news_card.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/v_app_header.dart';
import 'package:visionsafe/app/data/services/news_service.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';
import 'package:visionsafe/app/core/values/app_design.dart';
import 'package:visionsafe/app/presentation/global_widgets/templates/base_screen_template.dart';
import 'package:visionsafe/app/presentation/global_widgets/atoms/v_shimmer.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/v_empty_state.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/vizo_mascot.dart';
import 'widgets/proximity_warning_overlay.dart';
import 'widgets/compact_status_card.dart';
import 'widgets/compact_action_button.dart';
import 'package:visionsafe/app/presentation/global_widgets/animations/fade_in_up.dart';

/// HomeView: The Hero Experience.
class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final newsService = Get.find<NewsService>();

    return Obx(() {
      final isViolation = controller.isViolation;
      
      return BaseScreenTemplate(
        appBar: const VAppHeader(title: "VISIONSAFE"),
        bottomPadding: 160,
        stackLayers: [
          ProximityWarningOverlay(isViolation: isViolation),
        ],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            
            // 2. Interactive Radar Assistant
            FadeInUp(
              delay: const Duration(milliseconds: 300),
              child: const Center(child: RepaintBoundary(child: LiveVizoRadar())),
            ),
            
            const SizedBox(height: 32),
            
            // 3. Quick Control Center
            _buildAnimatedEntry(
              delay: 450,
              child: const Row(
                children: [
                  Expanded(child: CompactStatusCard()),
                  SizedBox(width: AppDesign.space16),
                  Expanded(child: CompactActionButton()),
                ],
              ),
            ),
            
            const SizedBox(height: 16), // Reduced spacing
            
            // 4. Live Health Metrics
            _buildAnimatedEntry(
              delay: 600,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle("RINGKASAN HARI INI"),
                  const SizedBox(height: 8), // Tight spacing to grid
                  const QuickStatsGrid(),
                ],
              ),
            ),
            
            const SizedBox(height: 16), // Reduced spacing to news
            
            // 5. Intelligent Eye Care Content
            _buildAnimatedEntry(
              delay: 750,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildNewsHeader(),
                  const SizedBox(height: 8), // Tight spacing to list
                  _buildNewsList(newsService),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildNewsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildSectionTitle("BERITA KESEHATAN"),
        GestureDetector(
          onTap: () => Get.toNamed('/news'),
          child: Text(
            "LIHAT SEMUA",
            style: AppTextStyles.caption.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w900,
              fontSize: 10,
              letterSpacing: 1.0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNewsList(NewsService newsService) {
    return Obx(() {
      if (newsService.isLoading.value) {
        return Column(
          children: List.generate(2, (index) => const Padding(
            padding: EdgeInsets.only(bottom: AppDesign.spaceM),
            child: VShimmer(width: double.infinity, height: 110),
          )),
        );
      }
      if (newsService.newsList.isEmpty) {
        return const VEmptyState(
          title: "Kabar Dari Vizo",
          description: "Vizo belum menemukan artikel baru hari ini. Ayo jaga kesehatan matamu!",
          mascotState: VizoState.sleeping,
        );
      }
      return Column(
        children: newsService.newsList.take(3).map((news) => Padding(
          padding: const EdgeInsets.only(bottom: AppDesign.spaceM),
          child: EyeCareNewsCard(news: news),
        )).toList(),
      );
    });
  }

  Widget _buildAnimatedEntry({required Widget child, int delay = 0}) {
    return FadeInUp(
      delay: Duration(milliseconds: delay),
      child: child,
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.caption.copyWith(
        fontSize: 11,
        color: AppColors.primaryDark,
        fontWeight: FontWeight.w900,
        letterSpacing: 2.0,
      ),
    );
  }
}
