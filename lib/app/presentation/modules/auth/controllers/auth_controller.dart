import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visionsafe/app/routes/app_pages.dart';
import 'package:visionsafe/app/data/repositories/auth_repository.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/v_toast.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/vizo_mascot.dart';

/// Controller untuk manajemen state dan logika UI Autentikasi.
class AuthController extends GetxController {
  final _authRepository = Get.find<AuthRepository>();
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
      _safeOffAll(Routes.mainWrapper);
    } catch (e) {
      VToast.show("Kesalahan Login", "Email atau password salah.", state: VizoState.worried);
    } finally {
      if (!_isDisposed) isLoading.value = false;
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
      
      VToast.show("Selamat Datang!", "Akun Hero kamu berhasil dibuat. Silakan login.", state: VizoState.happy);
      _safeOffAll(Routes.login);
    } catch (e) {
      VToast.show("Gagal Daftar", "Email mungkin sudah digunakan atau jaringan bermasalah.", state: VizoState.intervention);
    } finally {
      if (!_isDisposed) isLoading.value = false;
    }
  }

  /// Mengeksekusi login melalui Google OAuth.
  Future<void> loginWithGoogle() async {
    isLoading.value = true;
    try {
      await _authRepository.loginWithGoogle();
      _safeOffAll(Routes.mainWrapper);
    } catch (e) {
      VToast.show("Kesalahan Google Auth", "Gagal masuk dengan Google.", state: VizoState.worried);
    } finally {
      if (!_isDisposed) isLoading.value = false;
    }
  }

  bool _validateLoginInput() {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      VToast.show("Input Tidak Valid", "Mohon isi email dan password.", state: VizoState.worried);
      return false;
    }
    return true;
  }

  bool _validateRegisterInput() {
    if (nameController.text.isEmpty || emailController.text.isEmpty || passwordController.text.isEmpty) {
      VToast.show("Input Kosong", "Semua kolom wajib diisi.", state: VizoState.worried);
      return false;
    }
    if (passwordController.text != confirmPasswordController.text) {
      VToast.show("Password Berbeda", "Konfirmasi password tidak cocok.", state: VizoState.sad);
      return false;
    }
    if (passwordController.text.length < 6) {
      VToast.show("Password Lemah", "Minimal 6 karakter ya Hero!", state: VizoState.worried);
      return false;
    }
    return true;
  }

  bool _isDisposed = false;

  @override
  void onClose() {
    _isDisposed = true;
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void _safeOffAll(String route) {
    if (!_isDisposed) Get.offAllNamed(route);
  }
}
