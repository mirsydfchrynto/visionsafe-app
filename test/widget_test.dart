import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:visionsafe/app/data/models/telemetry_model.dart';
import 'package:visionsafe/app/data/providers/vision_service_provider.dart';
import 'package:visionsafe/app/presentation/modules/home/controllers/home_controller.dart';
import 'package:visionsafe/app/presentation/modules/home/views/home_view.dart';
import 'package:visionsafe/app/data/services/telemetry_service.dart';
import 'package:visionsafe/app/data/services/config_service.dart';
import 'package:visionsafe/app/data/services/sync_service.dart';

class MockVisionServiceProvider extends GetxService
    implements VisionServiceProvider {
  bool isRunning = false;

  @override
  Future<void> startService() async {
    isRunning = true;
  }

  @override
  Future<void> stopService() async {
    isRunning = false;
  }

  @override
  Future<bool> isServiceRunning() async => isRunning;

  @override
  Future<void> updateThreshold(double threshold) async {}

  @override
  Stream<TelemetryModel> get telemetryStream => const Stream.empty();
}

void main() {
  setUp(() async {
    Get.put(SyncService());
    await Get.putAsync(() => ConfigService().init());
    await Get.putAsync(() => TelemetryService().init());
    Get.put<VisionServiceProvider>(MockVisionServiceProvider());
    Get.put<HomeController>(HomeController());
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets('HomeView renders and shows initial state', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const GetMaterialApp(home: HomeView()));
    expect(find.text('VISIONSAFE'), findsOneWidget);
    expect(find.text('VIZO SEDANG ISTIRAHAT'), findsOneWidget);
    expect(find.text('AKTIFKAN VIZO!'), findsOneWidget);
  });
}
