import 'package:flutter/material.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';

/// VButton: Tombol utama dengan gaya 2D Hero Quest.
class VButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color color;
  final bool isLoading;
  final IconData? icon;

  const VButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.color = const Color(0xFF0056B3), // Hero Blue
    this.isLoading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: Container(
        height: 60,
        width: double.infinity,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: AppColors.charcoal, width: 2.5),
        ),
        child: Center(
          child: isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null) ...[
                      Icon(icon, color: Colors.white, size: 20),
                      const SizedBox(width: 10),
                    ],
                    Text(
                      label.toUpperCase(),
                      style: AppTextStyles.bodyBold.copyWith(
                        color: Colors.white,
                        letterSpacing: 1.5,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
