import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:visionsafe/app/data/services/telemetry_service.dart';
import 'package:visionsafe/app/data/services/config_service.dart';
import 'package:visionsafe/app/data/providers/vision_service_provider.dart';
import 'package:visionsafe/app/data/services/reward_service.dart';

class CalibrationController extends GetxController {
  final telemetryService = Get.find<TelemetryService>();
  final _configService = Get.find<ConfigService>();
  final _visionProvider = Get.find<VisionServiceProvider>();
  final _rewardService = Get.find<RewardService>();
  final _supabase = Supabase.instance.client;
  final _logger = Logger();

  final currentDistance = 0.0.obs;
  final isSaving = false.obs;
  
  CameraController? cameraController;

  @override
  void onInit() {
    super.onInit();
    _initCamera();
    _startCalibrationEngine();
    
    ever(telemetryService.currentDistance, (double distance) {
      currentDistance.value = distance;
    });
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      final frontCamera = cameras.firstWhere((c) => c.lensDirection == CameraLensDirection.front);
      
      cameraController = CameraController(frontCamera, ResolutionPreset.medium, enableAudio: false);
      await cameraController!.initialize();
      update(); // Refresh UI for CameraPreview
    } catch (e) {
      _logger.e("Gagal inisialisasi kamera preview: $e");
    }
  }

  Future<void> _startCalibrationEngine() async {
    final isRunning = await _visionProvider.isServiceRunning();
    if (!isRunning) {
      await _visionProvider.startService();
    }
  }

  /// Menyimpan hasil kalibrasi ke Lokal (Hive) dan Cloud (Supabase).
  Future<void> saveCalibration() async {
    if (currentDistance.value < 30.0) {
      Get.snackbar("Aduh!", "Jarak minimal 30 cm ya Hero!");
      return;
    }

    isSaving.value = true;
    try {
      final double newThreshold = currentDistance.value;

      // 1. Simpan ke Hive (Offline First)
      await _configService.setThreshold(newThreshold);
      
      // 2. Simpan ke Supabase (Cloud Sync)
      final user = _supabase.auth.currentUser;
      if (user != null) {
        await _supabase.from('user_settings').upsert({
          'user_id': user.id,
          'safe_distance': newThreshold,
          'updated_at': DateTime.now().toIso8601String(),
        });
        _logger.i("Cloud Sync: Jarak aman berhasil disimpan di Supabase.");
      }

      // 3. Update Native Service
      await _visionProvider.updateThreshold(newThreshold);
      
      _rewardService.unlockSticker('s3');

      Get.back();
      Get.snackbar(
        "Berhasil!",
        "Jarak aman matamu sekarang: ${newThreshold.toInt()} cm.",
        backgroundColor: Colors.green.withAlpha(50),
      );
    } catch (e) {
      _logger.e("Gagal sinkronisasi kalibrasi: $e");
      Get.snackbar("Error", "Gagal menyimpan ke cloud, tapi tetap tersimpan di HP.");
    } finally {
      isSaving.value = false;
    }
  }

  @override
  void onClose() {
    cameraController?.dispose();
    super.onClose();
  }
}
