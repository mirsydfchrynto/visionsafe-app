import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// VizoMascot: "The Dual Cyber Buddies" (SDA Elite Standard).
/// Gaya: Dua Maskot Berdampingan, Masing-masing satu mata (Total 2 mata).
/// Memenuhi permintaan user: "Maskotnya dua agar bermata 2".
class VizoMascot extends StatelessWidget {
  final double size;
  final VizoState state;

  const VizoMascot({
    super.key, 
    this.size = 180, 
    this.state = VizoState.idle
  });

  @override
  Widget build(BuildContext context) {
    return _AnimatedDualMascot(size: size, state: state);
  }

  static Color getStateColor(VizoState state) {
    switch (state) {
      case VizoState.worried: return Colors.orangeAccent;
      case VizoState.intervention: return Colors.redAccent;
      case VizoState.exercise: return Colors.greenAccent;
      default: return const Color(0xFF3A86FF); // Cyber Blue
    }
  }
}

class _AnimatedDualMascot extends StatefulWidget {
  final double size;
  final VizoState state;
  const _AnimatedDualMascot({required this.size, required this.state});

  @override
  State<_AnimatedDualMascot> createState() => _AnimatedDualMascotState();
}

class _AnimatedDualMascotState extends State<_AnimatedDualMascot> with TickerProviderStateMixin {
  late AnimationController _floatController;
  late AnimationController _breathController;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat(reverse: true);
    _breathController = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatController.dispose();
    _breathController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color baseColor = VizoMascot.getStateColor(widget.state);
    final double individualSize = widget.size * 0.48;

    return AnimatedBuilder(
      animation: Listenable.merge([_floatController, _breathController]),
      builder: (context, child) {
        final double floatY = -10 * _floatController.value;
        final double scale = 0.98 + (0.04 * _breathController.value);

        return Transform.translate(
          offset: Offset(0, floatY),
          child: Transform.scale(
            scale: scale,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildSingleVizo(individualSize, baseColor, isLeft: true),
                SizedBox(width: widget.size * 0.05),
                _buildSingleVizo(individualSize, baseColor, isLeft: false),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSingleVizo(double size, Color color, {required bool isLeft}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color.withAlpha(255),
            color,
            color.withAlpha(180),
          ],
          center: Alignment(isLeft ? 0.2 : -0.2, -0.3),
          radius: 0.9,
        ),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(30), blurRadius: 10, offset: const Offset(0, 8)),
          BoxShadow(color: color.withAlpha(60), blurRadius: 20),
        ],
        border: Border.all(color: Colors.white.withAlpha(100), width: 2),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Glossy Shine
          Positioned(
            top: size * 0.15,
            left: isLeft ? size * 0.2 : size * 0.3,
            child: Container(
              width: size * 0.2,
              height: size * 0.1,
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(100),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),

          // Pipi Merah (Optional for cuteness)
          Positioned(
            bottom: size * 0.2,
            child: _buildBlush(size * 0.2),
          ),

          // One Big Eye per Mascot (Total 2)
          _buildEye(size * 0.75),
        ],
      ),
    );
  }

  Widget _buildEye(double eyeSize) {
    return SizedBox(
      width: eyeSize,
      height: eyeSize,
      child: Lottie.asset(
        'assets/animations/eye_blink.json',
        fit: BoxFit.contain,
        delegates: LottieDelegates(
          values: [
            ValueDelegate.color(const ['**', 'Fill 1', '**'], value: const Color(0xFF0D0D0D)),
            ValueDelegate.color(const ['**', 'Stroke 1', '**'], value: const Color(0xFF795548)),
          ],
        ),
      ),
    );
  }

  Widget _buildBlush(double blushSize) {
    return Container(
      width: blushSize,
      height: blushSize * 0.5,
      decoration: BoxDecoration(
        color: Colors.pinkAccent.withAlpha(60),
        borderRadius: BorderRadius.all(Radius.elliptical(blushSize, blushSize * 0.5)),
      ),
    );
  }
}


enum VizoState { idle, worried, intervention, sleeping, exercise }
