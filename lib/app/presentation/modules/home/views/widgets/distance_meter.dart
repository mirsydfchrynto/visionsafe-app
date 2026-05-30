import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visionsafe/app/presentation/modules/home/controllers/home_controller.dart';

/// Meteran jarak real-time dengan progress bar.
class DistanceMeter extends GetView<HomeController> {
  const DistanceMeter({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!controller.isServiceRunning) return const SizedBox.shrink();

      final distance = controller.telemetryService.currentDistance.value;
      final isViolation = controller.telemetryService.isViolation.value;
      final color = isViolation ? Colors.red : Colors.green;

      return Container(
        margin: const EdgeInsets.only(top: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color, width: 2),
        ),
        child: Column(
          children: [
            _buildHeader(distance, color, isViolation),
            const SizedBox(height: 12),
            _buildProgressBar(distance, color),
          ],
        ),
      );
    });
  }

  Widget _buildHeader(double distance, Color color, bool isViolation) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Estimasi Jarak Mata:",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(
          "${distance.toStringAsFixed(1)} cm",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar(double distance, Color color) {
    return LinearProgressIndicator(
      value: (distance / 100).clamp(0.0, 1.0),
      backgroundColor: Colors.white,
      color: color,
      minHeight: 10,
      borderRadius: BorderRadius.circular(5),
    );
  }
}
