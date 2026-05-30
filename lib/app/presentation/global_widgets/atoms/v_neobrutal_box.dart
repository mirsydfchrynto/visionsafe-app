import 'package:flutter/material.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_design.dart';

/// VNeobrutalBox: Atom dasar untuk kontainer bergaya Neobrutalist.
/// Mengkonsolidasikan logika Border + Shadow untuk konsistensi seluruh aplikasi.
class VNeobrutalBox extends StatelessWidget {
  final Widget child;
  final Color color;
  final double radius;
  final double borderWidth;
  final Offset shadowOffset;
  final List<BoxShadow>? customShadow;
  final EdgeInsetsGeometry? padding;
  final BoxBorder? customBorder;

  const VNeobrutalBox({
    super.key,
    required this.child,
    this.color = Colors.white,
    this.radius = AppDesign.radiusM,
    this.borderWidth = AppDesign.borderWidth,
    this.shadowOffset = const Offset(AppDesign.shadowOffset, AppDesign.shadowOffset),
    this.customShadow,
    this.padding,
    this.customBorder,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
        border: customBorder ?? Border.all(color: AppColors.primaryDark, width: borderWidth),
        boxShadow: customShadow ?? [
          BoxShadow(
            color: AppColors.primaryDark,
            offset: shadowOffset,
          ),
        ],
      ),
      child: child,
    );
  }
}
