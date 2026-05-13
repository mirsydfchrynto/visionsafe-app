import 'package:get/get.dart';
import '../controllers/main_wrapper_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../stats/controllers/stats_controller.dart';
import '../../play/controllers/play_controller.dart';
import '../../quests/controllers/quests_controller.dart';
import 'package:visionsafe/app/data/providers/vision_service_provider.dart';

/// MainWrapperBinding: Pusat Dependency Injection untuk Tab Utama.
/// Memastikan semua controller tersedia saat navigasi IndexedStack.
class MainWrapperBinding extends Bindings {
  @override
  void dependencies() {
    // Daftarkan provider secara permanen
    Get.put(VisionServiceProvider(), permanent: true); 
    
    // Inisialisasi semua controller tab agar tersedia di IndexedStack
    Get.put(MainWrapperController());
    Get.put(HomeController());
    Get.put(StatsController());
    Get.put(PlayController());
    Get.put(QuestsController());
  }
}
