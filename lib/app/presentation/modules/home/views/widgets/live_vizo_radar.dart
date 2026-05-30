import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';
import 'package:visionsafe/app/core/values/app_design.dart';
import 'package:visionsafe/app/presentation/modules/home/controllers/home_controller.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/vizo_mascot.dart';

/// LiveVizoRadar: Premium interactive assistant with dynamic status visual feedback.
class LiveVizoRadar extends StatefulWidget {
  const LiveVizoRadar({super.key});

  @override
  State<LiveVizoRadar> createState() => _LiveVizoRadarState();
}

class _LiveVizoRadarState extends State<LiveVizoRadar> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  final controller = Get.find<HomeController>();
  bool _isSurprised = false;

  void _handleTap() {
    if (_isSurprised) return;
    
    HapticFeedback.heavyImpact();
    setState(() => _isSurprised = true);
    
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) setState(() => _isSurprised = false);
    });
  }

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final distance = controller.telemetryService.currentDistance.value;
      final isViolation = controller.telemetryService.isViolation.value;
      final accentColor = isViolation ? AppColors.danger : AppColors.primary;
      
      return AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          // AAA Dynamics: Combined Pulse, Scale, and Float Y
          final double pulseValue = _pulseController.value;
          double scale = 1.0 + (pulseValue * 0.04);
          if (isViolation) scale = 1.0 + (pulseValue * 0.12); // Urgent alert scale
          
          final double floatY = -8 * pulseValue;

          return Transform.translate(
            offset: Offset(0, floatY),
            child: Transform.scale(
              scale: scale,
              child: Container(
                height: 240,
                width: 240,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppDesign.radiusXL),
                  border: Border.all(
                    color: accentColor, 
                    width: isViolation ? 8 : 6,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: accentColor.withValues(alpha: 0.15 + (pulseValue * 0.1)),
                      blurRadius: 32,
                      spreadRadius: 8 * pulseValue,
                    ),
                    BoxShadow(
                      color: AppColors.primaryDark.withValues(alpha: 0.8),
                      offset: const Offset(8, 8),
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Subtle Background Glow
                    Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        color: accentColor.withValues(alpha: 0.05),
                        shape: BoxShape.circle,
                      ),
                    ),
                    
                    _buildMascot(isViolation),
                    
                    // High-End Status Badge
                    Positioned(
                      bottom: 20,
                      child: _buildStatusBadge(distance, isViolation),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    });
  }

  Widget _buildStatusBadge(double distance, bool isViolation) {
    return AnimatedContainer(
      duration: AppDesign.medium,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isViolation ? AppColors.danger : AppColors.success,
        borderRadius: BorderRadius.circular(AppDesign.radiusFull),
        border: Border.all(color: AppColors.primaryDark, width: 3),
        boxShadow: const [BoxShadow(color: AppColors.primaryDark, offset: Offset(3, 3))],
      ),
      child: Text(
        distance > 0 ? "${distance.toInt()} CM" : "SCANNING...",
        style: AppTextStyles.bodyBold.copyWith(
          color: isViolation ? Colors.white : AppColors.primaryDark, 
          fontSize: 20, 
          fontWeight: FontWeight.w900,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildMascot(bool isViolation) {
    VizoState mascotState = isViolation ? VizoState.worried : VizoState.idle;
    if (_isSurprised) mascotState = VizoState.surprised;

    return VizoMascot(
      size: 140,
      state: mascotState,
      onTap: _handleTap,
    );
  }
}
