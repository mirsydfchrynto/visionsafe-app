import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visionsafe/app/routes/app_pages.dart';

/// OnboardingController: Logika navigasi slide onboarding.
class OnboardingController extends GetxController {
  final pageController = PageController();
  final currentPage = 0.obs;

  final List<Map<String, String>> pages = [
    {
      'title': 'HALO! AKU VIZO',
      'desc': 'Aku akan jadi sahabatmu untuk menjaga mata tetap sehat dan kuat!',
      'image': 'assets/images/onboarding_1.svg',
    },
    {
      'title': 'JAGA JARAKMU',
      'desc': 'Jangan terlalu dekat ya! Vizo akan kasih tahu kalau kamu keasyikan main HP.',
      'image': 'assets/images/onboarding_2.svg',
    },
    {
      'title': 'SIAP BERPETUALANG?',
      'desc': 'Ayo aktifkan penjagaan Vizo dan kumpulkan Koleksi Hero keren setiap harinya!',
      'image': 'assets/images/onboarding_3.svg',
    },
  ];

  bool get isLastPage => currentPage.value == pages.length - 1;

  void updatePageIndex(int index) => currentPage.value = index;

  void nextPage() {
    if (isLastPage) {
      Get.offAllNamed(Routes.login);
    } else {
      pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
