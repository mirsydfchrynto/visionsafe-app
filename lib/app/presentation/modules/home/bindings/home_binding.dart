import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import 'package:visionsafe/app/data/providers/vision_service_provider.dart';
import 'package:visionsafe/app/data/services/telemetry_service.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Enterprise Standard: Pastikan semua dependensi inti tersedia sebelum UI dirender
    Get.lazyPut<VisionServiceProvider>(() => VisionServiceProvider());
    
    // HomeController butuh TelemetryService & ConfigService yang sudah di-put di main.dart
    // Namun kita pastikan di sini agar redundansi aman jika dipanggil secara independen
    if (!Get.isRegistered<TelemetryService>()) {
      Get.lazyPut<TelemetryService>(() => TelemetryService());
    }
    
    Get.lazyPut<HomeController>(() => HomeController());
  }
}
