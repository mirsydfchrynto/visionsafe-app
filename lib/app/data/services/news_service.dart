import 'package:get/get.dart';
import 'package:logger/logger.dart';

class NewsModel {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String category;
  final String url;
  final DateTime publishedAt;

  NewsModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.category,
    required this.url,
    required this.publishedAt,
  });

  factory NewsModel.fromMap(Map<String, dynamic> map) {
    return NewsModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['image_url'] ?? '',
      category: map['category'] ?? 'Edukasi',
      url: map['url'] ?? 'https://www.who.int/news-room/questions-and-answers/item/blindness-and-vision-impairment',
      publishedAt: DateTime.parse(map['published_at'] ?? DateTime.now().toIso8601String()),
    );
  }
}

class NewsService extends GetxService {
  final newsList = <NewsModel>[].obs;
  final isLoading = false.obs;
  final _logger = Logger();

  Future<NewsService> init() async {
    await fetchNews();
    return this;
  }

  Future<void> fetchNews() async {
    isLoading.value = true;
    try {
      // Simulasi real-time fetching (Dapat dihubungkan ke API News atau Supabase)
      await Future.delayed(const Duration(seconds: 1));
      
      final mockData = [
        {
          'id': '1',
          'title': 'Pentingnya Aturan 20-20-20',
          'description': 'Langkah sederhana menjaga kesehatan mata saat belajar online dengan HP.',
          'image_url': 'https://images.unsplash.com/photo-1516733725897-1aa73b87c8e8?w=500',
          'category': 'Edukasi',
          'url': 'https://www.healthline.com/health/eye-health/20-20-20-rule',
          'published_at': DateTime.now().toIso8601String(),
        },
        {
          'id': '2',
          'title': 'Bahaya Gadget di Tempat Gelap',
          'description': 'Kenapa kamu tidak boleh main HP sambil mematikan lampu kamar?',
          'image_url': 'https://images.unsplash.com/photo-1541178735423-479332dfa93b?w=500',
          'category': 'Tips Sehat',
          'url': 'https://www.sleepfoundation.org/bedroom-environment/blue-light',
          'published_at': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
        },
        {
          'id': '3',
          'title': 'Makanan Peningkat Penglihatan',
          'description': 'Wortel bukan satu-satunya! Cek daftar makanan enak untuk mata kuat.',
          'image_url': 'https://images.unsplash.com/photo-1584447128309-b66b7a4d1b63?w=500',
          'category': 'Nutrisi',
          'url': 'https://www.aao.org/eye-health/tips-prevention/diet-nutrition',
          'published_at': DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
        }
      ];

      newsList.assignAll(mockData.map((e) => NewsModel.fromMap(e)).toList());
    } catch (e) {
      _logger.e("Gagal fetch berita: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
