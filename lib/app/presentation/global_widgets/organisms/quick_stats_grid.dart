import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';
import 'package:visionsafe/app/core/values/app_design.dart';
import 'package:visionsafe/app/presentation/global_widgets/atoms/v_card.dart';
import 'package:visionsafe/app/presentation/modules/home/controllers/home_controller.dart';

/// QuickStatsGrid: Organism untuk menampilkan ringkasan statistik harian.
class QuickStatsGrid extends GetView<HomeController> {
  const QuickStatsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: EdgeInsets.zero, // Remove default padding
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: AppDesign.spaceM,
      mainAxisSpacing: AppDesign.spaceM,
      childAspectRatio: 0.82,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label, 
                style: AppTextStyles.caption.copyWith(
                  fontWeight: FontWeight.w900, 
                  fontSize: 10, 
                  color: AppColors.primaryDark.withAlpha(180),
                  letterSpacing: 1.0,
                )
              ),
              Icon(icon, color: color, size: 20),
            ],
          ),
          const SizedBox(height: AppDesign.spaceS),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(value, style: AppTextStyles.heading1.copyWith(fontSize: 32, height: 1, color: AppColors.primaryDark)),
              const SizedBox(width: AppDesign.spaceXS),
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Text(unit, style: AppTextStyles.caption.copyWith(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.grey)),
              ),
            ],
          ),
          const SizedBox(height: AppDesign.spaceM),
          Divider(height: 1, thickness: 1, color: AppColors.primaryDark.withAlpha(30)),
          const SizedBox(height: AppDesign.spaceS),
          ...subInfo.map((info) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(info['label'] ?? '', style: AppTextStyles.caption.copyWith(fontSize: 9, fontWeight: FontWeight.w600)),
                Text(
                  info['value'] ?? info['size'] ?? '', 
                  style: AppTextStyles.caption.copyWith(fontSize: 9, fontWeight: FontWeight.w900, color: AppColors.primaryDark),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
