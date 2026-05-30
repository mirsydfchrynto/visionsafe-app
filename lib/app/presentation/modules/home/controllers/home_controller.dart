import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:visionsafe/app/data/providers/vision_service_provider.dart';
import 'package:visionsafe/app/data/services/telemetry_service.dart';
import 'package:visionsafe/app/data/services/auth_service.dart';
import 'package:visionsafe/app/data/services/config_service.dart';
import 'package:visionsafe/app/data/repositories/telemetry_repository.dart';
import 'package:visionsafe/app/routes/app_pages.dart';
import 'package:visionsafe/app/data/repositories/profile_repository.dart';
import 'package:visionsafe/app/data/models/profile_model.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/v_dialog.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/v_toast.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/vizo_mascot.dart';

class HomeController extends GetxController with WidgetsBindingObserver {
  final _logger = Logger();
  final _serviceProvider = Get.find<VisionServiceProvider>();
  final telemetryService = Get.find<TelemetryService>();
  final _configService = Get.find<ConfigService>();
  final _repository = TelemetryRepository();
  final _profileRepo = Get.find<ProfileRepository>();

  final isLoading = false.obs;
  final isBackendConnected = false.obs;
  final dailyViolationMinutes = 0.0.obs;
  
  final userProfile = Rxn<ProfileModel>();
  bool _wasServiceRunningBeforePause = false;
  DateTime? _lastHapticTime;

  bool get isServiceRunning => _configService.isServiceEnabled.value;
  double get currentDistance => telemetryService.currentDistance.value;
  bool get isViolation => telemetryService.isViolation.value;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    _checkInitialPermissions();
    _startConnectivityPolling();
    _listenToProfile();

    ever(telemetryService.currentDistance, _handleUxFeedback);
    ever(telemetryService.isViolation, (_) => _updateStats());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused && isServiceRunning) {
      _wasServiceRunningBeforePause = true;
      _serviceProvider.stopService();
      _configService.toggleService(false);
      _logger.i("Lifecycle: Menangguhkan layanan VisionSafe.");
    } else if (state == AppLifecycleState.resumed && _wasServiceRunningBeforePause) {
      _wasServiceRunningBeforePause = false;
      _serviceProvider.startService().then((_) {
        _configService.toggleService(true);
        _logger.i("Lifecycle: Mengaktifkan kembali layanan VisionSafe.");
      });
    }
  }

  StreamSubscription? _profileSubscription;

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    _profileSubscription?.cancel();
    super.onClose();
  }

  void _listenToProfile() {
    final authService = Get.find<AuthService>();
    ever(authService.isLoggedIn, (bool loggedIn) {
      _profileSubscription?.cancel();
      if (loggedIn) {
        _profileSubscription = _profileRepo.watchMyProfile().listen(
          (profile) => userProfile.value = profile,
          onError: (e) => _logger.e("Gagal memantau profil: $e"),
        );
      } else {
        userProfile.value = null;
      }
    });

    if (authService.isLoggedIn.value) {
      _profileSubscription = _profileRepo.watchMyProfile().listen(
        (profile) => userProfile.value = profile,
        onError: (e) => _logger.e("Gagal memantau profil awal: $e"),
      );
    }
  }

  void _startConnectivityPolling() {
    _checkConnection();
    Timer.periodic(const Duration(seconds: 30), (_) => _checkConnection());
  }

  Future<void> _checkConnection() async {
    try {
      final result = await InternetAddress.lookup('supabase.co').timeout(const Duration(seconds: 5));
      isBackendConnected.value = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      isBackendConnected.value = false;
    }
  }

  void _handleUxFeedback(double distance) {
    final threshold = _configService.threshold.value;
    final now = DateTime.now();
    if (distance < threshold + 2.0 && distance >= threshold) {
      if (_lastHapticTime == null || now.difference(_lastHapticTime!).inSeconds >= 5) {
        HapticFeedback.lightImpact();
        _lastHapticTime = now;
      }
    }
  }

  void _updateStats() {
    dailyViolationMinutes.value = _repository.calculateViolationMinutesToday();
  }

  void goToCalibration() => Get.toNamed(Routes.calibration);

  Future<void> _checkInitialPermissions() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }

  Future<void> toggleService() async {
    final previousState = _configService.isServiceEnabled.value;
    
    // Optimistic state transition
    _configService.toggleService(!previousState);
    HapticFeedback.mediumImpact();
    
    try {
      if (previousState) {
        await _serviceProvider.stopService();
        VToast.show("VisionSafe", "Layanan Penjaga Mata Dinonaktifkan.", state: VizoState.sleeping);
      } else {
        if (!await Permission.camera.isGranted && !(await Permission.camera.request().isGranted)) {
          _configService.toggleService(previousState);
          _showPermissionError("Kamera");
          return;
        }
        if (!await Permission.systemAlertWindow.isGranted && !(await Permission.systemAlertWindow.request().isGranted)) {
          _configService.toggleService(previousState);
          _showPermissionError("Tampilkan di Atas Aplikasi Lain");
          return;
        }
        if (!await Permission.notification.isGranted) {
          await Permission.notification.request();
        }
        await _serviceProvider.startService();
        VToast.show("VisionSafe", "Layanan Penjaga Mata Aktif!", state: VizoState.happy);
      }
    } catch (e) {
      _configService.toggleService(previousState);
      VToast.show("Ups!", "Terjadi kesalahan: ${e.toString()}", state: VizoState.intervention);
    }
  }

  void _showPermissionError(String permissionName) {
    VDialog.show(
      title: "Izin Dibutuhkan",
      message: "VisionSafe butuh izin $permissionName agar bisa berfungsi melindungi mata Anda.",
      confirmLabel: "PENGATURAN",
      onConfirm: () {
        openAppSettings();
      },
      cancelLabel: "NANTI",
    );
  }
}
