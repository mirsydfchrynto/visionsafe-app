import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/play_controller.dart';
import 'widgets/play_card.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';
import 'package:visionsafe/app/presentation/global_widgets/templates/base_screen_template.dart';

/// PlayView: Area edukasi dan mini-games ringan.
/// Mematuhi aturan Micro-File & Modular UI.
class PlayView extends GetView<PlayController> {
  const PlayView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreenTemplate(
      appBar: AppBar(
        title: Text('DUNIA BERMAIN', style: AppTextStyles.heading2),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      bottomPadding: 140,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("PILIH PETUALANGANMU", style: AppTextStyles.bodyBold),
          const SizedBox(height: 16),
          _buildPlayGrid(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildPlayGrid() {
    return Obx(() => GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: controller.games.length,
      itemBuilder: (context, index) {
        return PlayCard(game: controller.games[index]);
      },
    ));
  }
}
