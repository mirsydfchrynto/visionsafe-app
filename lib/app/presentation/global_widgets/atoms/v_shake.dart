import 'package:flutter/material.dart';

class VShake extends StatefulWidget {
  final Widget child;
  final Stream<void>? triggerStream;

  const VShake({
    super.key,
    required this.child,
    this.triggerStream,
  });

  @override
  State<VShake> createState() => _VShakeState();
}

class _VShakeState extends State<VShake> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _offsetAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 12.0), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 12.0, end: -10.0), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: -10.0, end: 8.0), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 8.0, end: -6.0), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: -6.0, end: 4.0), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 4.0, end: 0.0), weight: 1),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    widget.triggerStream?.listen((_) {
      if (mounted) {
        _controller.forward(from: 0.0);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _offsetAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_offsetAnimation.value, 0),
          child: widget.child,
        );
      },
      child: widget.child,
    );
  }
}
