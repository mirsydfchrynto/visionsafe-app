import 'package:flutter/material.dart';

/// Section bantuan/informasi fitur.
/// File: guide_section.dart (< 100 lines)
class GuideSection extends StatelessWidget {
  const GuideSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Tentang VisionSafe",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _buildGuideCard(
          icon: Icons.face_retouching_natural,
          title: "Face Mesh Detection",
          desc: "Memantau jarak mata menggunakan 468 titik landmark wajah secara presisi.",
        ),
        const SizedBox(height: 12),
        _buildGuideCard(
          icon: Icons.blur_on,
          title: "Auto-Intervention",
          desc: "Memberikan efek blur otomatis jika mata terdeteksi terlalu dekat dengan layar.",
        ),
        const SizedBox(height: 12),
        _buildGuideCard(
          icon: Icons.battery_saver,
          title: "Battery Optimized",
          desc: "Menggunakan teknik sampling hemat daya yang tidak menguras baterai ponsel.",
        ),
      ],
    );
  }

  Widget _buildGuideCard({
    required IconData icon,
    required String title,
    required String desc,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withAlpha(26)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent[400], size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text(desc, style: const TextStyle(fontSize: 12, color: Colors.black54)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
