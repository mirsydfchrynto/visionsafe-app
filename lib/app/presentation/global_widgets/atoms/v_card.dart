import 'package:flutter/material.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';

/// VCard: Container kartu dengan gaya 2D Comic/Playful.
/// Mematuhi aturan Micro-File (< 100 baris).
class VCard extends StatelessWidget {
  final Widget child;
  final Color color;
  final double padding;
  final BoxBorder? border;
  final List<BoxShadow>? boxShadow;

  const VCard({
    super.key,
    required this.child,
    this.color = Colors.white,
    this.padding = 16.0,
    this.border,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
        border: border ?? Border.all(color: AppColors.charcoal, width: 3),
        boxShadow: boxShadow ?? const [
          BoxShadow(
            color: AppColors.charcoal,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }
}
