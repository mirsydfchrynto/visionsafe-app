import 'package:flutter/material.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';

/// Input field dengan gaya Retro 2D.
/// Mendukung prefixIcon untuk estetika Hero Quest.
class VInput extends StatelessWidget {
  final String? label;
  final String hint;
  final bool isPassword;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final IconData? prefixIcon;

  const VInput({
    super.key,
    this.label,
    this.hint = "",
    this.isPassword = false,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(label!.toUpperCase(), style: AppTextStyles.caption.copyWith(color: AppColors.charcoal, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
        ],
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: AppColors.charcoal, width: 2.5),
          ),
          child: TextField(
            controller: controller,
            obscureText: isPassword,
            keyboardType: keyboardType,
            style: AppTextStyles.bodyBold.copyWith(color: AppColors.charcoal),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppTextStyles.caption.copyWith(color: Colors.grey.shade400),
              prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: Colors.grey.shade600, size: 22) : null,
              contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}
