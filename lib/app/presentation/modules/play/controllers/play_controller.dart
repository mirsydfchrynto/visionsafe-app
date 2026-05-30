import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';

class PlayController extends GetxController {
  final games = <Map<String, dynamic>>[
    {
      'title': 'Kuis Sehat',
      'icon': Icons.quiz,
      'color': AppColors.secondary,
      'route': null,
    },
    {
      'title': 'Cari Vizo',
      'icon': Icons.search,
      'color': Colors.orange,
      'route': null,
    },
    {
      'title': 'Tips Seru',
      'icon': Icons.lightbulb,
      'color': Colors.purple,
      'route': null,
    },
  ].obs;
}
