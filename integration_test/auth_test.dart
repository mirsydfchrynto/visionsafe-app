import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:visionsafe/main.dart' as app;
import 'package:visionsafe/app/data/repositories/auth_repository.dart';
import 'package:get/get.dart';
import 'package:visionsafe/app/data/services/auth_service.dart';
import 'package:visionsafe/app/data/services/config_service.dart';
import 'package:visionsafe/app/data/services/reward_service.dart';
import 'package:visionsafe/app/data/services/sync_service.dart';
import 'package:visionsafe/app/data/services/telemetry_service.dart';

/// Automated Authentication Testing (Standard SDA V2 - Stabilized).
/// Memenuhi Skenario A, B, C, dan D untuk Validasi Web Service.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // Helper untuk inisialisasi environment testing secara utuh
  Future<void> setupTestEnvironment() async {
    if (!Get.isRegistered<AuthService>()) {
      await Get.putAsync(() => ConfigService().init());
      Get.put(AuthService());
      await Get.putAsync(() => RewardService().init());
      Get.put(SyncService());
      await Get.putAsync(() => TelemetryService().init());
    }
  }

  group('PENGUJIAN AUTENTIKASI OTOMATIS (SUPABASE)', () {
    final testEmail = 'hero_test_${DateTime.now().millisecondsSinceEpoch}@example.com';
    final testPassword = 'Password123!';

    testWidgets('Skenario A: Validasi Kegagalan Login', (tester) async {
      // 1. Inisialisasi Aplikasi
      app.main();
      await tester.pumpAndSettle();
      await setupTestEnvironment();

      final authRepo = AuthRepository();

      // 2. Pastikan dalam keadaan logout
      if (authRepo.isAuthenticated) await authRepo.logout();

      // 3. Eksekusi Login dengan kredensial salah
      bool hasError = false;
      try {
        await authRepo.login('unknown@hero.com', 'wrongpass');
      } catch (e) {
        hasError = true;
      }
      
      expect(hasError, true);
      debugPrint('Skenario A Berhasil: Sistem menolak kredensial salah.');
    });

    testWidgets('Skenario B: Registrasi Akun Baru & Duplikasi', (tester) async {
      await setupTestEnvironment();
      final authRepo = AuthRepository();

      // 1. Registrasi Sukses
      await authRepo.register(testEmail, testPassword, name: 'Hero Tester');
      await Future.delayed(const Duration(seconds: 2)); // Beri waktu network
      
      expect(authRepo.currentUser != null, true);
      debugPrint('Skenario B (1) Berhasil: Akun baru terdaftar di Supabase.');

      // 2. Cek Duplikasi (Harus Gagal)
      bool hasDuplicateError = false;
      try {
        await authRepo.register(testEmail, testPassword);
      } catch (e) {
        hasDuplicateError = true;
      }
      
      expect(hasDuplicateError, true);
      debugPrint('Skenario B (2) Berhasil: Sistem mencegah pendaftaran email ganda.');
      
      await authRepo.logout();
    });

    testWidgets('Skenario C: Login Sukses & Validasi Sesi', (tester) async {
      await setupTestEnvironment();
      final authRepo = AuthRepository();

      await authRepo.login(testEmail, testPassword);
      await Future.delayed(const Duration(seconds: 2));
      
      expect(authRepo.isAuthenticated, true);
      expect(authRepo.currentUser?.email, testEmail);
      debugPrint('Skenario C Berhasil: Sesi valid ditemukan setelah login.');
    });

    testWidgets('Skenario D: Persistensi Sesi & Siklus Token', (tester) async {
      await setupTestEnvironment();
      final authRepo = AuthRepository();

      // 1. Validasi Persistensi
      expect(authRepo.isAuthenticated, true);
      debugPrint('Skenario D (1) Berhasil: Sesi bertahan (Persistence).');

      // 2. Simulasi Siklus Token (Logout -> Login)
      await authRepo.logout();
      await Future.delayed(const Duration(seconds: 1));
      expect(authRepo.isAuthenticated, false);
      
      await authRepo.login(testEmail, testPassword);
      await Future.delayed(const Duration(seconds: 2));
      expect(authRepo.isAuthenticated, true);
      debugPrint('Skenario D (2) Berhasil: Siklus token aman.');
    });
  });
}
