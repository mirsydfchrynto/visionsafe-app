import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';
import 'package:visionsafe/app/data/services/sync_service.dart';
import 'package:visionsafe/app/data/services/telemetry_service.dart';
import 'package:visionsafe/app/data/services/config_service.dart';
import 'package:visionsafe/app/data/services/auth_service.dart';
import 'package:visionsafe/app/data/services/supabase_service.dart';
import 'package:visionsafe/app/data/services/reward_service.dart';
import 'package:visionsafe/app/data/services/news_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 1. Inisialisasi Supabase (Pondasi Backend)
  await Supabase.initialize(
    url: 'https://tkfxqlpmccnpzefywkef.supabase.co',
    anonKey: 'sb_publishable_CA0kVCgcofJgmibNNW6-9w_osXCd4Cx', 
  );

  // 2. Inisialisasi Hive (Pondasi Local Storage)
  await Hive.initFlutter();

  // 3. Inisialisasi Layanan Global (GetX Dependency Injection)
  await Get.putAsync(() => ConfigService().init());
  Get.put(AuthService()); 
  Get.put(SupabaseService()); // Explicitly put SupabaseService
  await Get.putAsync(() => RewardService().init());
  Get.put(SyncService());
  await Get.putAsync(() => TelemetryService().init());
  await Get.putAsync(() => NewsService().init());

  runApp(
    GetMaterialApp(
      title: "VisionSafe",
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
    ),
  );
}
