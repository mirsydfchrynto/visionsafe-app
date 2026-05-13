import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import '../models/sticker_model.dart';

/// Layanan untuk mengelola sistem reward dan koleksi stiker.
class RewardService extends GetxService {
  final _logger = Logger();
  late Box<StickerModel> _stickerBox;
  
  final unlockedStickers = <StickerModel>[].obs;

  Future<RewardService> init() async {
    // Registrasi Adapter (Wajib untuk tipe data kustom di Hive)
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(StickerModelAdapter());
    }

    _stickerBox = await Hive.openBox<StickerModel>('vizo_stickers');
    
    if (_stickerBox.isEmpty) {
      await _initializeDefaultStickers();
    }
    
    _loadUnlockedStickers();
    return this;
  }

  Future<void> _initializeDefaultStickers() async {
    final defaults = [
      StickerModel(id: 's1', title: 'Si Mata Elang', description: 'Jaga jarak aman selama 30 menit.'),
      StickerModel(id: 's2', title: 'Pendekar Vizo', description: 'Gunakan VisionSafe selama 3 hari berturut-turut.'),
      StickerModel(id: 's3', title: 'Master Kalibrasi', description: 'Selesaikan kalibrasi pertama matamu.'),
      StickerModel(id: 's4', title: 'Sahabat Sehat', description: 'Selesaikan 5 kali senam mata.'),
    ];

    for (var sticker in defaults) {
      await _stickerBox.put(sticker.id, sticker);
    }
    _logger.i('Reward Service: Stiker default berhasil diinisialisasi.');
  }

  void _loadUnlockedStickers() {
    unlockedStickers.value = _stickerBox.values.where((s) => s.isUnlocked).toList();
  }

  Future<void> unlockSticker(String id) async {
    final sticker = _stickerBox.get(id);
    if (sticker != null && !sticker.isUnlocked) {
      final updated = StickerModel(
        id: sticker.id,
        title: sticker.title,
        description: sticker.description,
        isUnlocked: true,
        unlockedAt: DateTime.now(),
      );
      await _stickerBox.put(id, updated);
      _loadUnlockedStickers();
      
      Get.snackbar(
        "Koleksi Baru!",
        "Hero baru bergabung: ${updated.title}",
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 4),
      );
      _logger.i('Reward Unlocked: ${updated.title}');
    }
  }

  List<StickerModel> getAllStickers() => _stickerBox.values.toList();
}
