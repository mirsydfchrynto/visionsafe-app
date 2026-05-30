import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';
import 'package:visionsafe/app/presentation/modules/home/controllers/home_controller.dart';

/// VAppHeader: World-Class Solid Header for VisionSafe.
/// Prevents content overlap and provides clear status feedback.
class VAppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showStatus;
  final List<Widget>? actions;

  const VAppHeader({
    super.key, 
    required this.title,
    this.showStatus = true,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Column(
        children: [
          const SizedBox(height: 12),
          Text(
            title.toUpperCase(), 
            style: AppTextStyles.heading2.copyWith(
              letterSpacing: 2, 
              color: AppColors.primaryDark,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            )
          ),
          if (showStatus) _buildConnectionStatus(),
        ],
      ),
      centerTitle: true,
      backgroundColor: Colors.white, // Solid white to prevent overlap
      elevation: 0,
      actions: actions,
      automaticallyImplyLeading: false,
      shape: Border(
        bottom: BorderSide(
          color: AppColors.primaryDark.withValues(alpha: 0.1),
          width: 2,
        ),
      ),
    );
  }

  Widget _buildConnectionStatus() {
    if (!Get.isRegistered<HomeController>()) {
      return const SizedBox.shrink();
    }
    
    final controller = Get.find<HomeController>();
    
    return Obx(() {
      final isOnline = controller.isBackendConnected.value;
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isOnline ? AppColors.success : AppColors.danger,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            isOnline ? "CLOUD SYNC: ON" : "CLOUD SYNC: OFF",
            style: TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.w900,
              color: (isOnline ? AppColors.success : AppColors.danger).withValues(alpha: 0.8),
            ),
          ),
        ],
      );
    });
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
