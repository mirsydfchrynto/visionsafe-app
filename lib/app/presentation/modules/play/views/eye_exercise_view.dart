import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/eye_exercise_controller.dart';
import 'package:visionsafe/app/presentation/global_widgets/atoms/v_button.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/vizo_mascot.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';

class EyeExerciseView extends GetView<EyeExerciseController> {
  const EyeExerciseView({super.key});

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('SENAM MATA', style: AppTextStyles.heading2),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() => _buildVisualGuide(controller)),
            const SizedBox(height: 48),
            Obx(() => _buildInstruction(controller)),
            const SizedBox(height: 60),
            Obx(() => _buildActionButton(controller)),
          ],
        ),
      ),
    );
  }

  Widget _buildVisualGuide(EyeExerciseController controller) {
    return Column(
      children: [
        VizoMascot(state: controller.isRunning.value ? VizoState.exercise : VizoState.idle),
        const SizedBox(height: 24),
        if (controller.isRunning.value)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.charcoal, width: 3),
            ),
            child: Text(
              "${controller.timeLeft.value} DETIK",
              style: AppTextStyles.bodyBold.copyWith(color: Colors.white),
            ),
          ),
      ],
    );
  }

  Widget _buildInstruction(EyeExerciseController controller) {
    if (!controller.isRunning.value) {
      return Column(
        children: [
          Text(
            "SIAP MULAI?",
            style: AppTextStyles.heading1,
          ),
          const SizedBox(height: 12),
          Text(
            "Ikuti gerakan Vizo untuk mengistirahatkan matamu.",
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium,
          ),
        ],
      );
    }

    final step = controller.steps[controller.currentStep.value];
    return Column(
      children: [
        Text(
          step['title']!.toUpperCase(),
          style: AppTextStyles.heading1.copyWith(color: AppColors.primary),
        ),
        const SizedBox(height: 12),
        Text(
          step['instruction']!,
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildActionButton(EyeExerciseController controller) {
    if (controller.isRunning.value) {
      return Text(
        "LANGKAH ${controller.currentStep.value + 1} DARI ${controller.steps.length}",
        style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold),
      );
    }

    return VButton(
      label: "MULAI SEKARANG",
      onPressed: () => controller.startExercise(),
    );
  }
}
