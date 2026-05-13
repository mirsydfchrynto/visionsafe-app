import 'package:hive/hive.dart';

part 'sticker_model.g.dart';

@HiveType(typeId: 2)
class StickerModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final bool isUnlocked;

  @HiveField(4)
  final DateTime? unlockedAt;

  StickerModel({
    required this.id,
    required this.title,
    required this.description,
    this.isUnlocked = false,
    this.unlockedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isUnlocked': isUnlocked,
      'unlockedAt': unlockedAt?.toIso8601String(),
    };
  }
}
