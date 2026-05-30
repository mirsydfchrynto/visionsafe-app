import 'package:flutter/material.dart';
import 'package:visionsafe/app/core/values/app_design.dart';

/// FadeInUp: AAA Standard entrance animation for components.
class FadeInUp extends StatelessWidget {
  final Widget child;
  final Duration delay;
  final double offset;

  const FadeInUp({
    super.key, 
    required this.child, 
    this.delay = Duration.zero,
    this.offset = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: AppDesign.slow,
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, offset * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
