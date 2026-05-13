import 'package:get/get.dart';

/// MainWrapperController: Mengelola index navigasi utama aplikasi.
/// Mendukung 3 Tab Utama: BUDDY, STATS, QUESTS.
class MainWrapperController extends GetxController {
  final currentIndex = 0.obs;

  void changePage(int index) {
    currentIndex.value = index;
  }
}
