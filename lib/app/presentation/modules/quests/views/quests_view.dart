import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/quests_controller.dart';
import 'widgets/quests_header.dart';
import 'widgets/quests_journey_card.dart';
import 'package:visionsafe/app/presentation/global_widgets/templates/base_screen_template.dart';

import 'package:visionsafe/app/presentation/global_widgets/molecules/v_app_header.dart';

/// QuestsView: Gabungan Quests dan Koleksi Hero (Hero Journey).
/// Desain Premium: Bebas overflow, padat, dan mengikuti tema Retro-Glass.
/// File size strictly < 200 lines.
class QuestsView extends GetView<QuestsController> {
  const QuestsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const BaseScreenTemplate(
      appBar: VAppHeader(title: 'HERO JOURNEY'),
      bottomPadding: 180,
      child: Column(
        children: [
          QuestsHeader(),
          SizedBox(height: 24), // Increased spacing
          QuestsJourneyCard(),
        ],
      ),
    );
  }
}
