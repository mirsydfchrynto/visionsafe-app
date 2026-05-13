import 'package:get/get.dart';
import '../controllers/quests_controller.dart';

class QuestsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QuestsController>(() => QuestsController());
  }
}
