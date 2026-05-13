import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';
import 'package:visionsafe/app/presentation/global_widgets/atoms/v_button.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/vizo_mascot.dart';
import '../controllers/calibration_controller.dart';

/// View Kalibrasi Wajah Versi Pro dengan Live Camera Feed.
class CalibrationView extends GetView<CalibrationController> {
  const CalibrationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Dark Navy Enterprise
      body: Stack(
        children: [
          // 1. Background Camera Preview (Pondasi AI)
          _buildCameraPreview(),
          
          // 2. UI Overlay (Glassmorphism & Gradient)
          _buildUiOverlay(),
          
          // 3. Distance Meter & Info
          _buildDistanceMeter(),
          
          // 4. Action Controls
          _buildControls(),

          // 5. Back Button
          Positioned(
            top: 50,
            left: 16,
            child: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
              style: IconButton.styleFrom(backgroundColor: Colors.black26),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraPreview() {
    return GetBuilder<CalibrationController>(
      builder: (controller) {
        if (controller.cameraController == null || !controller.cameraController!.value.isInitialized) {
          return Container(color: Colors.black);
        }
        return SizedBox.expand(
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: controller.cameraController!.value.previewSize!.height,
              height: controller.cameraController!.value.previewSize!.width,
              child: CameraPreview(controller.cameraController!),
            ),
          ),
        );
      },
    );
  }

  Widget _buildUiOverlay() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            const Color(0xFF0F172A).withAlpha(150),
            const Color(0xFF0F172A),
          ],
        ),
      ),
    );
  }

  Widget _buildDistanceMeter() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Obx(() {
            final double distance = controller.currentDistance.value;
            final bool isDetected = distance > 0;
            return Column(
              children: [
                // Vizo Mascot Reaktif
                VizoMascot(
                  size: 180,
                  state: distance < 30 ? VizoState.worried : VizoState.idle,
                ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  decoration: BoxDecoration(
                    color: isDetected ? const Color(0xFF1E293B).withAlpha(200) : Colors.red.shade900.withAlpha(200),
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(
                      color: distance >= 30 ? AppColors.success : (isDetected ? Colors.orange : Colors.red), 
                      width: 4
                    ),
                    boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 20)],
                  ),
                  child: Text(
                    isDetected ? "${distance.toInt()} CM" : "MENCARI WAJAH...",
                    style: AppTextStyles.heading1.copyWith(color: Colors.white, fontSize: 36),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  distance >= 30 
                    ? "JARAK SUDAH IDEAL!" 
                    : (isDetected ? "TERLALU DEKAT! MUNDUR SEDIKIT" : "POSISIKAN WAJAH DI DEPAN KAMERA"),
                  style: AppTextStyles.bodyBold.copyWith(
                    color: distance >= 30 ? Colors.greenAccent : Colors.white70,
                    fontSize: 12,
                    letterSpacing: 1.2
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildControls() {
    return Positioned(
      bottom: 60,
      left: 40,
      right: 40,
      child: Column(
        children: [
          Obx(() {
            final bool isTooClose = controller.currentDistance.value < 30;
            return VButton(
              label: "KUNCI JARAK AMAN",
              icon: Icons.lock_outline_rounded,
              isLoading: controller.isSaving.value,
              onPressed: isTooClose ? () {} : () => controller.saveCalibration(),
            );
          }),
          const SizedBox(height: 20),
          Text(
            "Minimal jarak aman adalah 30 CM.",
            style: AppTextStyles.caption.copyWith(color: Colors.white38),
          ),
        ],
      ),
    );
  }
}
