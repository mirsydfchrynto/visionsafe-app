import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visionsafe/app/data/services/reward_service.dart';
import 'package:visionsafe/app/data/models/sticker_model.dart';

class QuestsController extends GetxController {
  final _rewardService = Get.find<RewardService>();

  final specialQuest = {
    'id': 'sq1',
    'title': 'Senam Mata Hero',
    'subtitle': 'Lakukan relaksasi mata sekarang',
    'status': 'active',
    'icon': Icons.visibility_rounded,
  }.obs;

  final quests = <Map<String, dynamic>>[
    {
      'id': 'q1',
      'title': 'Blink Marathon',
      'subtitle': 'Blink 50 times during use',
      'progress': 0.4,
      'status': 'active',
      'icon': Icons.remove_red_eye_rounded,
    },
    {
      'id': 'q2',
      'title': 'Distance Master',
      'subtitle': 'Maintain 30cm for 10 min',
      'progress': 0.7,
      'status': 'active',
      'icon': Icons.straighten_rounded,
    },
    {
      'id': 'q3',
      'title': 'Sunlight Seeker',
      'subtitle': 'Use outside for 15 mins',
      'progress': 0.0,
      'status': 'locked',
      'icon': Icons.wb_sunny_rounded,
    },
  ].obs;

  final heroes = <StickerModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadHeroes();
  }

  void _loadHeroes() {
    // Merged into one professional Hero collection
    heroes.value = _rewardService.getAllStickers();
  }

  void startTask(String id) {
    if (id == 'sq1') {
      Get.toNamed('/eye-exercise');
      return;
    }
    
    Get.snackbar(
      "Quest Activated", 
      "Challenge started! Keep focusing on your eye health.",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF003366).withAlpha(50),
    );
  }
}
