import 'package:flutter/material.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';
import 'package:visionsafe/app/presentation/global_widgets/atoms/v_card.dart';

class QuickActionTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const QuickActionTile({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: VCard(
        padding: 12,
        color: color.withAlpha(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.charcoal, width: 2),
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Text(title.toUpperCase(), style: AppTextStyles.bodyBold.copyWith(fontSize: 12)),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.charcoal),
          ],
        ),
      ),
    );
  }
}
