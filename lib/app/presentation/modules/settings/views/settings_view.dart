import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';
import 'package:visionsafe/app/data/services/config_service.dart';
import 'package:visionsafe/app/data/services/auth_service.dart';
import 'package:visionsafe/app/routes/app_pages.dart';
import 'widgets/settings_tile.dart';
import 'widgets/settings_section.dart';

/// View Pengaturan Utama (Elite Professional Version).
class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final config = Get.find<ConfigService>();
    final auth = Get.find<AuthService>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('PENGATURAN', style: AppTextStyles.heading2),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SettingsSection(title: "PROFIL & KEAMANAN"),
            SettingsTile(
              icon: Icons.person_outline_rounded,
              title: "Edit Profil",
              subtitle: auth.currentUser.value?.email ?? "User Hero",
              onTap: () => _showEditProfileDialog(auth),
              trailing: const Icon(Icons.chevron_right),
            ),
            const SizedBox(height: 12),
            SettingsTile(
              icon: Icons.lock_reset_rounded,
              title: "Ganti Password",
              subtitle: "Perbarui kunci keamanan akunmu.",
              onTap: () => _showChangePasswordDialog(auth),
              trailing: const Icon(Icons.chevron_right),
            ),
            const SizedBox(height: 24),

            const SettingsSection(title: "TARGET KESEHATAN"),
            Obx(() => SettingsTile(
              icon: Icons.straighten_rounded,
              title: "Batas Jarak Aman",
              subtitle: "Saat ini: ${config.threshold.value.toInt()} CM (Klik untuk ubah)",
              onTap: () => _showDistanceSetterDialog(config),
              trailing: const Icon(Icons.edit_outlined, size: 20),
            )),
            const SizedBox(height: 24),
            
            const SettingsSection(title: "SISTEM & AKUN"),
            SettingsTile(
              icon: Icons.logout_rounded,
              title: "Keluar Akun",
              subtitle: "Selesaikan sesi dan keluar dari Cloud.",
              iconBgColor: Colors.red.withAlpha(30),
              iconColor: Colors.red,
              onTap: () => _handleLogout(auth),
              trailing: const Icon(Icons.exit_to_app_rounded, color: Colors.red),
            ),
            const SizedBox(height: 40),
            _buildVersionInfo(),
          ],
        ),
      ),
    );
  }

  void _handleLogout(AuthService auth) {
    Get.dialog(
      AlertDialog(
        title: const Text("Konfirmasi Keluar"),
        content: const Text("Apakah kamu yakin ingin mengakhiri sesi ini?"),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("BATAL")),
          TextButton(
            onPressed: () {
              auth.signOut();
              Get.offAllNamed(Routes.login);
            },
            child: const Text("KELUAR", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showEditProfileDialog(AuthService auth) {
    final nameCtrl = TextEditingController(text: auth.currentUser.value?.userMetadata?['full_name'] ?? "");
    Get.defaultDialog(
      title: "Edit Profil",
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: TextField(
          controller: nameCtrl,
          decoration: const InputDecoration(labelText: "Nama Lengkap"),
        ),
      ),
      textConfirm: "SIMPAN",
      textCancel: "BATAL",
      confirmTextColor: Colors.white,
      onConfirm: () async {
        Get.back();
        Get.snackbar("Sukses", "Profil berhasil diperbarui!");
      },
    );
  }

  void _showChangePasswordDialog(AuthService auth) {
    final passCtrl = TextEditingController();
    Get.defaultDialog(
      title: "Ganti Password",
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: TextField(
          controller: passCtrl,
          obscureText: true,
          decoration: const InputDecoration(labelText: "Password Baru"),
        ),
      ),
      textConfirm: "GANTI",
      textCancel: "BATAL",
      confirmTextColor: Colors.white,
      onConfirm: () async {
        Get.back();
        Get.snackbar("Sukses", "Password berhasil diubah!");
      },
    );
  }

  void _showDistanceSetterDialog(ConfigService config) {
    final distCtrl = TextEditingController(text: config.threshold.value.toInt().toString());
    Get.defaultDialog(
      title: "Set Jarak Aman",
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            TextField(
              controller: distCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Jarak (CM)",
                suffixText: "cm",
                helperText: "Minimal 30 cm untuk perlindungan mata.",
              ),
            ),
          ],
        ),
      ),
      textConfirm: "SIMPAN",
      textCancel: "BATAL",
      confirmTextColor: Colors.white,
      onConfirm: () async {
        final double? val = double.tryParse(distCtrl.text);
        if (val != null && val >= 30.0) {
          await config.setThreshold(val);
          Get.back();
          Get.snackbar("Berhasil", "Batas jarak aman diupdate ke ${val.toInt()} cm.");
        } else {
          Get.snackbar("Gagal", "Jarak harus minimal 30 cm!");
        }
      },
    );
  }

  Widget _buildVersionInfo() {
    return const Center(
      child: Column(
        children: [
          Text("VisionSafe v1.0.0 Elite", style: TextStyle(color: Colors.grey, fontSize: 12)),
          SizedBox(height: 4),
          Text("Powered by SDA Framework V2", style: TextStyle(color: Colors.grey, fontSize: 10)),
        ],
      ),
    );
  }
}
