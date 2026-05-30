import 'package:visionsafe/app/presentation/global_widgets/molecules/vizo_mascot.dart';

class NewsModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final String url;
  final DateTime publishedAt;
  final String sourceName;

  NewsModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.url,
    required this.publishedAt,
    required this.sourceName,
  });

  /// Maps target keywords in title/content to a suitable Vizo mascot emotion.
  VizoState get mascotState {
    final lowerTitle = title.toLowerCase();
    final lowerDesc = description.toLowerCase();
    
    final worriedKeywords = [
      'strain', 'addict', 'hazard', 'myopia', 'miopi', 'rabun', 'danger', 
      'risk', 'risiko', 'lelah', 'tired', 'dry eyes', 'sakit', 'pain', 'burnout'
    ];
    final exerciseKeywords = [
      'tips', 'exercise', 'senam', 'latihan', 'relax', 'istirahat', 'break'
    ];
    final focusedKeywords = [
      'focus', 'fokus', 'belajar', 'study', 'work', 'productivity', 'read', 'baca'
    ];
    final activeKeywords = [
      'posture', 'postur', 'duduk', 'sit', 'ergonomic', 'ergonomi'
    ];

    if (worriedKeywords.any((k) => lowerTitle.contains(k) || lowerDesc.contains(k))) {
      return VizoState.worried;
    }
    if (exerciseKeywords.any((k) => lowerTitle.contains(k) || lowerDesc.contains(k))) {
      return VizoState.exercise;
    }
    if (focusedKeywords.any((k) => lowerTitle.contains(k) || lowerDesc.contains(k))) {
      return VizoState.focused;
    }
    if (activeKeywords.any((k) => lowerTitle.contains(k) || lowerDesc.contains(k))) {
      return VizoState.happy;
    }
    return VizoState.idle;
  }

  /// Calculates estimated reading time in minutes (assuming 200 WPM).
  int get readingTimeMinutes {
    final words = description.split(RegExp(r'\s+')).length;
    final time = (words / 200).ceil();
    return time < 1 ? 1 : time;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': description,
      'category': category,
      'source_url': url,
      'created_at': publishedAt.toIso8601String(),
      'source_name': sourceName,
    };
  }

  factory NewsModel.fromMap(Map<String, dynamic> map) {
    return NewsModel(
      id: map['id']?.toString() ?? '',
      title: map['title'] ?? '',
      description: map['content'] ?? map['description'] ?? '',
      category: map['category'] ?? 'Edukasi',
      url: map['source_url'] ?? map['url'] ?? '',
      publishedAt: map['created_at'] != null 
          ? DateTime.tryParse(map['created_at'].toString()) ?? DateTime.now()
          : (map['publishedAt'] != null 
              ? DateTime.tryParse(map['publishedAt'].toString()) ?? DateTime.now()
              : DateTime.now()),
      sourceName: map['source_name'] ?? map['source'] ?? 'VisionSafe',
    );
  }
}
