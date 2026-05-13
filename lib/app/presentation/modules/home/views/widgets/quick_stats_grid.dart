import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';
import 'package:visionsafe/app/presentation/global_widgets/atoms/v_card.dart';
import '../../controllers/home_controller.dart';

class QuickStatsGrid extends GetView<HomeController> {
  const QuickStatsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 0.85, // Disesuaikan agar lebih tinggi untuk menampung sub-info
      children: [
        _buildStatItem(
          label: "SKOR MATA",
          value: "95",
          unit: "PT",
          icon: Icons.favorite_rounded,
          color: AppColors.danger,
          subInfo: [
            {'label': 'Layar', 'value': '4.5 Jam'},
            {'label': 'Sesi', 'size': '12 Kali'},
          ],
        ),
        _buildStatItem(
          label: "PELANGGARAN",
          value: "2",
          unit: "KALI",
          icon: Icons.warning_amber_rounded,
          color: Colors.orange,
          subInfo: [
            {'label': 'Jarak Rata', 'value': '38 cm'},
            {'label': 'Status', 'value': 'AMAN'},
          ],
        ),
      ],
    );
  }

  Widget _buildStatItem({
    required String label,
    required String value,
    required String unit,
    required IconData icon,
    required Color color,
    required List<Map<String, String>> subInfo,
  }) {
    return VCard(
      padding: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w900, fontSize: 11, color: const Color(0xFF003366))),
              Icon(icon, color: color, size: 20),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(value, style: AppTextStyles.heading1.copyWith(fontSize: 36, height: 1, color: const Color(0xFF003366))),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(unit, style: AppTextStyles.caption.copyWith(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, thickness: 1),
          const SizedBox(height: 12),
          ...subInfo.map((info) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(info['label'] ?? '', style: AppTextStyles.caption.copyWith(fontSize: 10, fontWeight: FontWeight.w600)),
                Text(
                  info['value'] ?? info['size'] ?? '', 
                  style: AppTextStyles.caption.copyWith(fontSize: 10, fontWeight: FontWeight.w900, color: const Color(0xFF003366)),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
