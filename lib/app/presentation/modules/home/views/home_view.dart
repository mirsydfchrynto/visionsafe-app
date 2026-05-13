import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import 'widgets/live_vizo_radar.dart';
import 'widgets/protection_status_card.dart';
import 'widgets/quick_stats_grid.dart';
import 'widgets/eye_care_news_card.dart';
import 'package:visionsafe/app/data/services/news_service.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final newsService = Get.find<NewsService>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 180), // Padding besar agar tidak tertutup nav
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(child: LiveVizoRadar()),
                const SizedBox(height: 32),
                
                _buildSectionTitle("KONTROL UTAMA"),
                _buildMainButton(),
                
                const SizedBox(height: 24),
                _buildSectionTitle("STATUS PERLINDUNGAN"),
                const ProtectionStatusCard(),
                
                const SizedBox(height: 24),
                _buildSectionTitle("RINGKASAN HARI INI"),
                const QuickStatsGrid(),
                
                const SizedBox(height: 24),
                _buildSectionTitle("BERITA KESEHATAN REAL-TIME"),
                Obx(() => newsService.isLoading.value 
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      children: newsService.newsList.map((news) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: EyeCareNewsCard(news: news),
                      )).toList(),
                    )
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: AppTextStyles.bodyBold.copyWith(
          fontSize: 12,
          color: const Color(0xFF003366).withAlpha(150),
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildMainButton() {
    return Obx(() => Container(
      width: double.infinity,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: (controller.isServiceRunning.value ? AppColors.danger : AppColors.success).withAlpha(80),
            offset: const Offset(0, 8),
            blurRadius: 15,
          )
        ],
      ),
      child: ElevatedButton(
        onPressed: () => controller.toggleService(),
        style: ElevatedButton.styleFrom(
          backgroundColor: controller.isServiceRunning.value ? AppColors.danger : AppColors.success,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: BorderSide(color: AppColors.charcoal, width: 4),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              controller.isServiceRunning.value ? Icons.stop_circle_rounded : Icons.play_circle_filled_rounded,
              size: 28,
            ),
            const SizedBox(width: 12),
            Text(
              controller.isServiceRunning.value ? "HENTIKAN PENJAGAAN" : "AKTIFKAN VIZO SEKARANG",
              style: AppTextStyles.bodyBold.copyWith(letterSpacing: 2, fontSize: 14),
            ),
          ],
        ),
      ),
    ));
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Column(
        children: [
          Text('VISIONSAFE', style: AppTextStyles.heading2.copyWith(letterSpacing: 2, color: const Color(0xFF003366))),
          Obx(() => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: controller.isBackendConnected.value ? Colors.green : Colors.red,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                controller.isBackendConnected.value ? "SUPABASE: ONLINE" : "SUPABASE: OFFLINE",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: (controller.isBackendConnected.value ? Colors.green : Colors.red).withAlpha(200),
                ),
              ),
            ],
          )),
        ],
      ),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.settings_suggest_rounded, color: Color(0xFF003366), size: 28),
          onPressed: () => Get.toNamed('/settings'),
        )
      ],
    );
  }
}
