import 'package:get/get.dart';
import '../controllers/calibration_controller.dart';

class CalibrationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CalibrationController>(
      () => CalibrationController(),
    );
  }
}
