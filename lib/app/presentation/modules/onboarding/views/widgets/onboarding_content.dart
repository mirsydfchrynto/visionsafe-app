import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';

/// OnboardingContent: Menampilkan Maskot, Judul, dan Deskripsi per slide.
class OnboardingContent extends StatelessWidget {
  final Map<String, String> page;

  const OnboardingContent({super.key, required this.page});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildIllustration(),
          const SizedBox(height: 48),
          Text(
            page['title'] ?? '',
            textAlign: TextAlign.center,
            style: AppTextStyles.heading1,
          ),
          const SizedBox(height: 16),
          Text(
            page['desc'] ?? '',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildIllustration() {
    return Container(
      height: 250,
      width: 250,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black, width: 4),
        boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(8, 8))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: SvgPicture.asset(
              page['image'] ?? '',
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: SvgPicture.asset(
              page['image'] ?? '',
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
