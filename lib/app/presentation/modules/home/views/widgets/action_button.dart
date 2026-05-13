import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visionsafe/app/presentation/modules/home/controllers/home_controller.dart';
import 'package:visionsafe/app/presentation/global_widgets/atoms/v_button.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';

class ActionButton extends GetView<HomeController> {
  const ActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => VButton(
      label: controller.isServiceRunning.value ? "ISTIRAHAT DULU" : "AKTIFKAN VIZO!",
      color: controller.isServiceRunning.value ? AppColors.charcoal : AppColors.primary,
      onPressed: controller.toggleService,
      isLoading: controller.isLoading.value,
    ));
  }
}
