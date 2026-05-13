import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visionsafe/app/presentation/modules/main_wrapper/controllers/main_wrapper_controller.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';

/// VBottomNav: Navigasi bawah kustom dengan gaya 2D Comic (3 Items).
/// Menerapkan Filosofi Zero-Redundancy & High-Contrast.
class VBottomNav extends GetView<MainWrapperController> {
  const VBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      margin: const EdgeInsets.fromLTRB(30, 0, 30, 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: const Color(0xFF003366), width: 3),
        boxShadow: const [BoxShadow(color: Color(0xFF003366), offset: Offset(0, 6))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(0, Icons.face_rounded, "BUDDY"),
          _buildNavItem(1, Icons.auto_graph_rounded, "STATS"),
          _buildNavItem(2, Icons.military_tech_rounded, "QUESTS"),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    return Obx(() {
      bool isSelected = controller.currentIndex.value == index;
      return GestureDetector(
        onTap: () => controller.changePage(index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF0056B3) : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : const Color(0xFF003366).withAlpha(150),
                size: 24,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                fontSize: 9,
                fontWeight: FontWeight.bold,
                color: isSelected ? const Color(0xFF003366) : const Color(0xFF003366).withAlpha(120),
              ),
            ),
          ],
        ),
      );
    });
  }
}
