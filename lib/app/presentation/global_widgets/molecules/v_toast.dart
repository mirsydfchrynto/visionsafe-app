import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/vizo_mascot.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/v_toast_widget.dart';

/// VToast: Sistem notifikasi melayang premium bergaya Morphing Glass-Bubble.
/// Menggunakan Overlay kustom dengan animasi pegas (spring/elastic) dan blur glassmorphism,
/// menghindari Snackbar bawaan sepenuhnya sesuai standar VisionSafe Elite.
class VToast {
  static OverlayEntry? _currentEntry;
  static int _currentToastId = 0;

  static void show(
    String title,
    String message, {
    VizoState state = VizoState.idle,
    Duration duration = const Duration(seconds: 3),
  }) {
    // Premium haptic feedback
    HapticFeedback.lightImpact();
    
    final context = Get.overlayContext ?? Get.context;
    if (context == null) return;

    // Menghapus toast sebelumnya jika ada secara aman
    if (_currentEntry != null) {
      final entry = _currentEntry!;
      _currentEntry = null;
      try {
        if (entry.mounted) {
          entry.remove();
        }
      } catch (_) {}
    }
    
    _currentToastId++;
    final toastId = _currentToastId;

    final entry = OverlayEntry(
      builder: (context) {
        return VToastWidget(
          title: title,
          message: message,
          state: state,
          duration: duration,
          onDismiss: () {
            if (_currentToastId == toastId) {
              if (_currentEntry != null) {
                final entryToRemove = _currentEntry!;
                _currentEntry = null;
                try {
                  if (entryToRemove.mounted) {
                    entryToRemove.remove();
                  }
                } catch (_) {}
              }
            }
          },
        );
      },
    );

    _currentEntry = entry;

    // Fortress-level robustness search for OverlayState
    OverlayState? overlayState;
    try {
      overlayState = Overlay.maybeOf(context);
    } catch (_) {}
    overlayState ??= Get.key.currentState?.overlay;

    if (overlayState == null) {
      // Graceful fallback to standard GetX snackbar to prevent unhandled exception crash
      Get.snackbar(
        title,
        message,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.white.withValues(alpha: 0.95),
        colorText: AppColors.primaryDark,
        margin: const EdgeInsets.all(16),
        borderRadius: 16,
        duration: duration,
        borderColor: VizoMascot.getStateColor(state).withValues(alpha: 0.35),
        borderWidth: 1.5,
        icon: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: VizoMascot(size: 28, state: state),
        ),
      );
      return;
    }

    overlayState.insert(entry);
  }
}
