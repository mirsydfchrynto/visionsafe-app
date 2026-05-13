import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visionsafe/app/routes/app_pages.dart';
import 'package:visionsafe/app/data/repositories/auth_repository.dart';

/// Controller untuk manajemen state dan logika UI Autentikasi.
class AuthController extends GetxController {
  final _authRepository = AuthRepository();
  final isLoading = false.obs;
  
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;

  @override
  void onInit() {
    super.onInit();
    _initializeControllers();
  }

  void _initializeControllers() {
    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  /// Mengeksekusi login standar melalui email dan password.
  Future<void> login() async {
    if (!_validateLoginInput()) return;

    isLoading.value = true;
    try {
      await _authRepository.login(emailController.text.trim(), passwordController.text.trim());
      Get.offAllNamed(Routes.mainWrapper);
    } catch (e) {
      Get.snackbar("Kesalahan Login", "Email atau password salah.");
    } finally {
      isLoading.value = false;
    }
  }

  /// Mengeksekusi pendaftaran akun baru (Register Manual).
  Future<void> register() async {
    if (!_validateRegisterInput()) return;

    isLoading.value = true;
    try {
      await _authRepository.register(
        emailController.text.trim(), 
        passwordController.text.trim(),
        name: nameController.text.trim(),
      );
      
      Get.snackbar("Selamat Datang!", "Akun Hero kamu berhasil dibuat. Silakan login.");
      Get.offAllNamed(Routes.login);
    } catch (e) {
      Get.snackbar("Gagal Daftar", "Email mungkin sudah digunakan atau jaringan bermasalah.");
    } finally {
      isLoading.value = false;
    }
  }

  /// Mengeksekusi login melalui Google OAuth.
  Future<void> loginWithGoogle() async {
    isLoading.value = true;
    try {
      await _authRepository.loginWithGoogle();
      Get.offAllNamed(Routes.mainWrapper);
    } catch (e) {
      Get.snackbar("Kesalahan Google Auth", "Gagal masuk dengan Google.");
    } finally {
      isLoading.value = false;
    }
  }

  bool _validateLoginInput() {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar("Input Tidak Valid", "Mohon isi email dan password.");
      return false;
    }
    return true;
  }

  bool _validateRegisterInput() {
    if (nameController.text.isEmpty || emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar("Input Kosong", "Semua kolom wajib diisi.");
      return false;
    }
    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar("Password Berbeda", "Konfirmasi password tidak cocok.");
      return false;
    }
    if (passwordController.text.length < 6) {
      Get.snackbar("Password Lemah", "Minimal 6 karakter ya Hero!");
      return false;
    }
    return true;
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
