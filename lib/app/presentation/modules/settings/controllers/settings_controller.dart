import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visionsafe/app/data/services/auth_service.dart';
import 'package:visionsafe/app/data/services/backend_api_service.dart';
import 'package:visionsafe/app/data/services/config_service.dart';
import 'package:visionsafe/app/presentation/modules/home/controllers/home_controller.dart';
import 'package:visionsafe/app/routes/app_pages.dart';

class SettingsController extends GetxController {
  final AuthService _auth = Get.find<AuthService>();
  final ConfigService config = Get.find<ConfigService>();
  final HomeController homeController = Get.find<HomeController>();
  final BackendApiService _backendApi = Get.find<BackendApiService>();

  final RxBool isLoading = false.obs;

  String get userEmail => _auth.currentUser.value?.email ?? 'User Hero';
  String get userName => _auth.currentUser.value?.userMetadata?['full_name'] as String? ?? 'VisionSafe Hero';

  void handleLogout() {
    Get.dialog<void>(
      AlertDialog(
        title: const Text('Konfirmasi Keluar'),
        content: const Text('Apakah kamu yakin ingin mengakhiri sesi ini?'),
        actions: [
          TextButton(onPressed: () => Get.back<void>(), child: const Text('BATAL')),
          TextButton(
            onPressed: () {
              _auth.signOut();
              Get.offAllNamed<void>(Routes.login);
            },
            child: const Text('KELUAR', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void showEditProfileDialog() {
    final nameCtrl = TextEditingController(text: userName);
    Get.defaultDialog<void>(
      title: 'Edit Profil',
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: TextField(
          controller: nameCtrl,
          decoration: const InputDecoration(labelText: 'Nama Lengkap'),
        ),
      ),
      textConfirm: 'SIMPAN',
      textCancel: 'BATAL',
      confirmTextColor: Colors.white,
      onConfirm: () async {
        if (nameCtrl.text.trim().isEmpty) return;
        Get.back<void>();
        isLoading.value = true;
        try {
          await _auth.updateProfile(name: nameCtrl.text.trim());
          Get.snackbar('Sukses', 'Profil berhasil diperbarui!');
        } catch (e) {
          Get.snackbar('Gagal', 'Terjadi kesalahan: $e');
        } finally {
          isLoading.value = false;
        }
      },
    );
  }

  void showChangePasswordDialog() {
    final passCtrl = TextEditingController();
    Get.defaultDialog<void>(
      title: 'Ganti Password',
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: TextField(
          controller: passCtrl,
          obscureText: true,
          decoration: const InputDecoration(labelText: 'Password Baru'),
        ),
      ),
      textConfirm: 'GANTI',
      textCancel: 'BATAL',
      confirmTextColor: Colors.white,
      onConfirm: () async {
        if (passCtrl.text.length < 6) {
          Get.snackbar('Gagal', 'Password minimal 6 karakter!');
          return;
        }
        Get.back<void>();
        isLoading.value = true;
        try {
          await _auth.updatePassword(passCtrl.text);
          Get.snackbar('Sukses', 'Password berhasil diubah!');
        } catch (e) {
          Get.snackbar('Gagal', 'Terjadi kesalahan: $e');
        } finally {
          isLoading.value = false;
        }
      },
    );
  }

  void showDistanceSetterDialog() {
    final distCtrl = TextEditingController(text: config.threshold.value.toInt().toString());
    Get.defaultDialog<void>(
      title: 'Set Jarak Aman',
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            TextField(
              controller: distCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Jarak (CM)',
                suffixText: 'cm',
                helperText: 'Minimal 30 cm untuk perlindungan mata.',
              ),
            ),
          ],
        ),
      ),
      textConfirm: 'SIMPAN',
      textCancel: 'BATAL',
      confirmTextColor: Colors.white,
      onConfirm: () {
        final val = double.tryParse(distCtrl.text);
        if (val != null && val >= 30.0) {
          config.setThreshold(val);
          Get.back<void>();
          Get.snackbar('Berhasil', 'Batas jarak aman diupdate ke ${val.toInt()} cm.');
        } else {
          Get.snackbar('Gagal', 'Jarak harus minimal 30 cm!');
        }
      },
    );
  }

  void showBackendIpDialog() {
    final ipCtrl = TextEditingController(text: _backendApi.baseUrl.replaceAll('http://', '').replaceAll(':8080/api/v1', ''));
    Get.defaultDialog<void>(
      title: 'Koneksi Backend Ktor',
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const Text(
              'Gunakan 10.0.2.2 untuk Emulator atau IP Laptop (misal: 192.168.1.5) jika pakai HP fisik.',
              style: TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: ipCtrl,
              decoration: const InputDecoration(
                labelText: 'IP Address / URL',
                hintText: 'Contoh: 192.168.1.5',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      textConfirm: 'SIMPAN',
      textCancel: 'BATAL',
      confirmTextColor: Colors.white,
      onConfirm: () {
        final ip = ipCtrl.text.trim();
        if (ip.isNotEmpty) {
          _backendApi.setBaseUrl(ip);
          Get.back<void>();
          Get.snackbar('Berhasil', 'Alamat backend diupdate.');
        }
      },
    );
  }
}
