import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:visionsafe/app/data/providers/vision_service_provider.dart';
import 'package:visionsafe/app/data/services/telemetry_service.dart';
import 'package:visionsafe/app/data/services/supabase_service.dart';
import 'package:visionsafe/app/data/services/config_service.dart';
import 'package:visionsafe/app/data/repositories/telemetry_repository.dart';
import 'package:visionsafe/app/routes/app_pages.dart';

class HomeController extends GetxController {
  final _serviceProvider = Get.find<VisionServiceProvider>();
  final telemetryService = Get.find<TelemetryService>();
  final _configService = Get.find<ConfigService>();
  final _repository = TelemetryRepository();

  final isServiceRunning = false.obs;
  final isLoading = false.obs;
  final isBackendConnected = false.obs;
  final dailyViolationMinutes = 0.0.obs;

  // Getters Reaktif untuk kemudahan akses di UI
  double get currentDistance => telemetryService.currentDistance.value;
  bool get isViolation => telemetryService.isViolation.value;

  @override
  void onInit() {
    super.onInit();
    _checkInitialPermissions();
    _startConnectivityPolling();
    
    // Sinkronisasi State Manual (Persistence Fix)
    isServiceRunning.value = _configService.isServiceEnabled.value;
    
    // Pastikan Native Service Sinkron saat Startup
    if (isServiceRunning.value) {
      _serviceProvider.startService();
    }

    // Listen perubahan data untuk update statistik & UX Feedback
    ever(telemetryService.currentDistance, (double distance) {
      _updateStats();
      _handleUxFeedback(distance);
    });
  }

  void _startConnectivityPolling() {
    final supabaseService = Get.find<SupabaseService>();
    // Cek koneksi setiap 30 detik secara background
    interval(isBackendConnected, (_) {}, time: const Duration(seconds: 30));
    _checkConnection(supabaseService);
    
    // Polling manual sederhana
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 30));
      if (!Get.isRegistered<HomeController>()) return false;
      await _checkConnection(supabaseService);
      return true;
    });
  }

  Future<void> _checkConnection(SupabaseService service) async {
    isBackendConnected.value = await service.checkConnection();
  }

  void _handleUxFeedback(double distance) {
    final threshold = _configService.threshold.value;
    if (distance < threshold + 2.0 && distance >= threshold) {
      HapticFeedback.lightImpact();
    }
  }

  void _updateStats() {
    dailyViolationMinutes.value = _repository.calculateViolationMinutesToday();
  }

  void goToCalibration() {
    Get.toNamed(Routes.calibration);
  }

  Future<void> _checkInitialPermissions() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }

  Future<void> toggleService() async {
    isLoading.value = true;

    try {
      if (isServiceRunning.value) {
        await _serviceProvider.stopService();
        await _configService.setServiceEnabled(false);
        isServiceRunning.value = false;
        Get.snackbar(
          "VisionSafe",
          "Layanan Penjaga Mata Dinonaktifkan.",
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        if (!await Permission.camera.isGranted) {
          final status = await Permission.camera.request();
          if (!status.isGranted) {
            _showPermissionError("Kamera");
            return;
          }
        }

        if (!await Permission.systemAlertWindow.isGranted) {
          final status = await Permission.systemAlertWindow.request();
          if (!status.isGranted) {
            _showPermissionError("Tampilkan di Atas Aplikasi Lain");
            return;
          }
        }

        if (!await Permission.notification.isGranted) {
          await Permission.notification.request();
        }

        await _serviceProvider.startService();
        await _configService.setServiceEnabled(true);
        isServiceRunning.value = true;

        Get.snackbar(
          "VisionSafe",
          "Layanan Penjaga Mata Aktif!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.blue.withAlpha(50),
        );
      }
    } catch (e) {
      Get.snackbar("Ups!", "Terjadi kesalahan: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  void _showPermissionError(String permissionName) {
    Get.defaultDialog(
      title: "Izin Dibutuhkan",
      middleText: "VisionSafe butuh izin $permissionName agar bisa berfungsi melindungi mata Anda.",
      textConfirm: "Buka Pengaturan",
      onConfirm: () {
        openAppSettings();
        Get.back();
      },
      textCancel: "Nanti Saja",
    );
  }
}
