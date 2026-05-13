import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';
import 'package:visionsafe/app/presentation/modules/home/controllers/home_controller.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/vizo_mascot.dart';

class LiveVizoRadar extends StatefulWidget {
  const LiveVizoRadar({super.key});

  @override
  State<LiveVizoRadar> createState() => _LiveVizoRadarState();
}

class _LiveVizoRadarState extends State<LiveVizoRadar> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  final controller = Get.find<HomeController>();

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final distance = controller.telemetryService.currentDistance.value;
      final isViolation = controller.telemetryService.isViolation.value;
      
      return AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          double scale = 1.0 + (_pulseController.value * 0.05);
          if (isViolation) scale = 1.0 + (_pulseController.value * 0.15); // Lebih agresif pas bahaya

          return Transform.scale(
            scale: scale,
            child: Container(
              height: 260,
              width: 260,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isViolation ? AppColors.danger : AppColors.primary, 
                  width: 8
                ),
                boxShadow: [
                  BoxShadow(
                    color: (isViolation ? AppColors.danger : AppColors.primary).withAlpha(100),
                    blurRadius: 20,
                    spreadRadius: 5 * _pulseController.value,
                  ),
                  const BoxShadow(color: AppColors.charcoal, offset: Offset(8, 8)),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  _buildMascot(isViolation),
                  Positioned(
                    bottom: 30,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: isViolation ? AppColors.danger : AppColors.success,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: AppColors.charcoal, width: 4),
                        boxShadow: const [BoxShadow(color: AppColors.charcoal, offset: Offset(4, 4))],
                      ),
                      child: Text(
                        distance > 0 ? "${distance.toInt()} CM" : "SCANNING...",
                        style: AppTextStyles.bodyBold.copyWith(color: Colors.white, fontSize: 22, letterSpacing: 1.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  Widget _buildMascot(bool isViolation) {
    return VizoMascot(
      size: 150,
      state: isViolation ? VizoState.worried : VizoState.idle,
    );
  }
}
