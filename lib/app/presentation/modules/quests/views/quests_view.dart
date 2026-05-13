import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/quests_controller.dart';
import 'widgets/quest_task_tile.dart';
import 'widgets/sticker_grid_item.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';

/// QuestsView: Gabungan Quests dan Koleksi Hero (Hero Journey).
/// Desain Premium: Bebas overflow, padat, dan mengikuti tema Retro-Glass.
class QuestsView extends GetView<QuestsController> {
  const QuestsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: _buildAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 140), // Ruang ekstra untuk nav
          child: Column(
            children: [
              _buildCompactHeader(),
              const SizedBox(height: 20),
              _buildMainJourneyCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompactHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF003366), Color(0xFF0056B3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: const Color(0xFF003366), width: 3),
        boxShadow: const [BoxShadow(color: Color(0xFF003366), offset: Offset(0, 6))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
            child: const Icon(Icons.stars_rounded, color: Colors.orangeAccent, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("QUEST MAP", style: AppTextStyles.bodyBold.copyWith(color: Colors.white, fontSize: 18)),
                Text("Selesaikan misi untuk stiker eksklusif!", 
                  style: AppTextStyles.caption.copyWith(color: Colors.white70, fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainJourneyCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(48),
        border: Border.all(color: const Color(0xFF003366), width: 3),
        boxShadow: const [BoxShadow(color: Color(0xFF003366), offset: Offset(0, 6))],
      ),
      child: Column(
        children: [
          const SizedBox(height: 24),
          // 1. Special Quest Section (Integrated Eye Exercise)
          _buildSpecialQuest(),
          
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(height: 1, indent: 40, endIndent: 40, thickness: 2),
          ),
          
          // 2. Daily Quests List
          _buildDailyQuests(),
          
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(height: 1, indent: 40, endIndent: 40, thickness: 2),
          ),

          // 3. Merged Collection Section
          _buildHeroCollection(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSpecialQuest() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("SPECIAL MISSION", 
            style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold, color: Colors.blue.shade700)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.withAlpha(20),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: Colors.blue.withAlpha(60), width: 1.5),
            ),
            child: Obx(() => QuestTaskTile(
              quest: controller.specialQuest,
              isLast: true,
            )),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyQuests() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("DAILY QUESTS", 
            style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF003366).withAlpha(150))),
          const SizedBox(height: 16),
          Obx(() => Column(
            children: List.generate(controller.quests.length, (index) {
              return QuestTaskTile(
                quest: controller.quests[index],
                isLast: index == controller.quests.length - 1,
              );
            }),
          )),
        ],
      ),
    );
  }

  Widget _buildHeroCollection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("KOLEKSI HERO", 
            style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF003366).withAlpha(150))),
          const SizedBox(height: 16),
          Obx(() {
            final int heroCount = controller.heroes.length;
            return Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.start,
              children: List.generate(8, (index) {
                final hero = index < heroCount ? controller.heroes[index] : null;
                return SizedBox(
                  width: (Get.width - 110) / 4,
                  child: StickerGridItem(sticker: hero),
                );
              }),
            );
          }),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('HERO JOURNEY', 
        style: TextStyle(color: Color(0xFF003366), fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 1)),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }
}
