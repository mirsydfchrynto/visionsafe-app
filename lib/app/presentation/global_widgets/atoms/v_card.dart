import 'package:flutter/material.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_design.dart';

/// VCard: Container kartu dengan gaya 2D Comic/Playful.
class VCard extends StatelessWidget {
  final Widget child;
  final Color color;
  final double? padding;
  final double? radius;
  final BoxBorder? border;
  final List<BoxShadow>? boxShadow;

  const VCard({
    super.key,
    required this.child,
    this.color = Colors.white,
    this.padding,
    this.radius,
    this.border,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding ?? AppDesign.spaceM),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius ?? AppDesign.radiusL),
        border: border ?? Border.all(color: AppColors.primaryDark, width: AppDesign.borderWidth),
        boxShadow: boxShadow ?? const [
          BoxShadow(
            color: AppColors.primaryDark,
            offset: Offset(AppDesign.shadowOffset, AppDesign.shadowOffset),
          ),
        ],
      ),
      child: child,
    );
  }
}
