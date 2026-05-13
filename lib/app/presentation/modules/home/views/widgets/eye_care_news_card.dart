import 'package:flutter/material.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';
import 'package:visionsafe/app/presentation/global_widgets/atoms/v_card.dart';
import 'package:visionsafe/app/data/services/news_service.dart';
import 'package:url_launcher/url_launcher.dart';

class EyeCareNewsCard extends StatelessWidget {
  final NewsModel news;

  const EyeCareNewsCard({super.key, required this.news});

  Future<void> _launchUrl() async {
    final Uri url = Uri.parse(news.url);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch ${news.url}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _launchUrl,
      child: VCard(
        padding: 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                _buildImage(),
                Positioned(
                  top: 12,
                  left: 12,
                  child: _buildCategoryBadge(),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    news.title, 
                    style: AppTextStyles.bodyBold.copyWith(fontSize: 18, color: const Color(0xFF003366)),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    news.description,
                    style: AppTextStyles.caption.copyWith(height: 1.5, fontSize: 13),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  _buildReadMoreButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFFF0F0F0),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: Image.network(
          news.imageUrl,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const Center(child: CircularProgressIndicator(strokeWidth: 2));
          },
          errorBuilder: (context, error, stackTrace) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.broken_image_rounded, size: 40, color: Colors.grey),
                  const SizedBox(height: 8),
                  Text("Gagal memuat gambar", style: AppTextStyles.caption.copyWith(fontSize: 10)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCategoryBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.charcoal, width: 2),
      ),
      child: Text(
        news.category.toUpperCase(),
        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildReadMoreButton() {
    return Row(
      children: [
        const Icon(Icons.link_rounded, size: 16, color: AppColors.primary),
        const SizedBox(width: 4),
        Text(
          "Baca Selengkapnya",
          style: AppTextStyles.bodyBold.copyWith(fontSize: 12, color: AppColors.primary),
        ),
      ],
    );
  }
}
