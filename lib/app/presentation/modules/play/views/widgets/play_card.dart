import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visionsafe/app/presentation/global_widgets/atoms/v_card.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';

/// PlayCard: Kartu pilihan game/edukasi dengan thumbnail ikon besar.
class PlayCard extends StatelessWidget {
  final Map<String, dynamic> game;

  const PlayCard({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (game['route'] != null) {
          Get.toNamed(game['route'] as String);
        } else {
          Get.snackbar(
            "Segera Hadir!",
            "Fitur ${game['title']} sedang dalam tahap pengembangan.",
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      },
      child: VCard(
        padding: 0, // VCard sekarang menerima double
        color: game['color'] as Color,
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Icon(game['icon'] as IconData, size: 50, color: game['color'] as Color),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    game['title'].toString().toUpperCase(),
                    textAlign: TextAlign.center,
                    style: AppTextStyles.caption.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
