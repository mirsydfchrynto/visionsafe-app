import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visionsafe/app/presentation/modules/home/controllers/home_controller.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/vizo_mascot.dart';

/// DistanceRadar: Visualisasi jarak mata anak secara real-time.
class DistanceRadar extends GetView<HomeController> {
  const DistanceRadar({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isRunning = controller.isServiceRunning.value;
      if (!isRunning) return _buildIdleState();

      final distance = controller.telemetryService.currentDistance.value;
      final isViolation = controller.telemetryService.isViolation.value;

      return Container(
        height: 220,
        width: 220,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.charcoal, width: 4),
          boxShadow: const [BoxShadow(color: AppColors.charcoal, offset: Offset(0, 6))],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            VizoMascot(state: isViolation ? VizoState.worried : VizoState.idle),
            _buildDistanceIndicator(distance, isViolation),
          ],
        ),
      );
    });
  }

  Widget _buildIdleState() {
    return const Center(child: VizoMascot(state: VizoState.sleeping));
  }

  Widget _buildDistanceIndicator(double distance, bool isViolation) {
    return Positioned(
      bottom: 20,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: isViolation ? AppColors.danger : AppColors.success,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.charcoal, width: 2),
        ),
        child: Text(
          "${distance.toStringAsFixed(1)} CM",
          style: const TextStyle(fontWeight: FontWeight.w900, color: Colors.white),
        ),
      ),
    );
  }
}
