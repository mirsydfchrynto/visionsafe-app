import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Seksi tombol media sosial (Google, Apple, Facebook).
class AuthSocialSection extends StatelessWidget {
  final VoidCallback onGoogleTap;
  final VoidCallback? onAppleTap;
  final VoidCallback? onFacebookTap;

  const AuthSocialSection({
    super.key,
    required this.onGoogleTap,
    this.onAppleTap,
    this.onFacebookTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSocialIcon(
          imageUrl: 'https://www.gstatic.com/images/branding/product/2x/googleg_48dp.png',
          onTap: onGoogleTap,
        ),
        const SizedBox(width: 24),
        _buildSocialIcon(
          iconData: Icons.apple_rounded,
          color: Colors.black,
          onTap: onAppleTap ?? () => Get.snackbar("Info", "Apple Auth segera hadir!"),
        ),
        const SizedBox(width: 24),
        _buildSocialIcon(
          iconData: Icons.facebook_rounded,
          color: const Color(0xFF1877F2),
          onTap: onFacebookTap ?? () => Get.snackbar("Info", "Facebook Auth segera hadir!"),
        ),
      ],
    );
  }

  Widget _buildSocialIcon({
    String? imageUrl,
    IconData? iconData,
    Color? color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 55,
        height: 55,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFF003366), width: 2),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
        ),
        child: Center(
          child: imageUrl != null
              ? Image.network(imageUrl, height: 28)
              : Icon(iconData, size: 28, color: color ?? Colors.black),
        ),
      ),
    );
  }
}
