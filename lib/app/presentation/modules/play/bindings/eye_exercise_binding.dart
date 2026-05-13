import 'package:get/get.dart';
import '../controllers/eye_exercise_controller.dart';

class EyeExerciseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EyeExerciseController>(() => EyeExerciseController());
  }
}
