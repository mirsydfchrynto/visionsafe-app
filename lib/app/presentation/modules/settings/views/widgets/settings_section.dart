import 'package:flutter/material.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';

/// Header seksi untuk mengelompokkan pengaturan secara logis.
class SettingsSection extends StatelessWidget {
  final String title;

  const SettingsSection({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(
        title,
        style: AppTextStyles.caption.copyWith(
          fontWeight: FontWeight.bold,
          color: AppColors.charcoal.withAlpha(150),
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
