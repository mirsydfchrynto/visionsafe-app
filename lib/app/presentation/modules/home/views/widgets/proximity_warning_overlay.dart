import 'package:flutter/material.dart';

class ProximityWarningOverlay extends StatefulWidget {
  final bool isViolation;
  const ProximityWarningOverlay({super.key, required this.isViolation});

  @override
  State<ProximityWarningOverlay> createState() => _ProximityWarningOverlayState();
}

class _ProximityWarningOverlayState extends State<ProximityWarningOverlay> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _opacityAnimation = Tween<double>(begin: 0.05, end: 0.35).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    if (widget.isViolation) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant ProximityWarningOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isViolation != oldWidget.isViolation) {
      if (widget.isViolation) {
        _controller.repeat(reverse: true);
      } else {
        _controller.stop();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isViolation) return const SizedBox.shrink();

    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _opacityAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.red.withValues(alpha: _opacityAnimation.value),
                width: 16,
              ),
              gradient: RadialGradient(
                colors: [
                  Colors.transparent,
                  Colors.red.withValues(alpha: _opacityAnimation.value * 0.5),
                ],
                stops: const [0.6, 1.0],
              ),
            ),
          );
        },
      ),
    );
  }
}
