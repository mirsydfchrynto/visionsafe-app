import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import 'package:crypto/crypto.dart';
import '../models/telemetry_model.dart';
import 'sync_service.dart';
import 'reward_service.dart';

/// Layanan Inti untuk orkestrasi aliran data telemetri.
class TelemetryService extends GetxService {
  static const _eventChannel = EventChannel('com.irsyad.visionsafe/telemetry');
  final _logger = Logger();
  final _syncService = Get.find<SyncService>();
  final _rewardService = Get.find<RewardService>();
  
  late Box _telemetryBox;
  final _batchThreshold = 10;

  int _safeDistanceSeconds = 0;

  final currentDistance = 0.0.obs;
  final isViolation = false.obs;

  Future<TelemetryService> init() async {
    final encryptionKey = sha256.convert(utf8.encode('visionsafe-super-secret-key')).bytes;
    
    _telemetryBox = await Hive.openBox(
      'telemetry_logs',
      encryptionCipher: HiveAesCipher(encryptionKey),
    );

    _listenToNativeTelemetry();
    return this;
  }

  void _listenToNativeTelemetry() {
    DateTime lastUiUpdateTime = DateTime.now();

    _eventChannel.receiveBroadcastStream().listen((dynamic event) {
      if (event is Map) {
        final model = TelemetryModel.fromMap(event);
        
        // Optimasi: Hanya update UI Reaktif maksimal 5 kali per detik (200ms)
        // Agar tidak terjadi 'Skipped Frames' saat user scrolling
        final now = DateTime.now();
        if (now.difference(lastUiUpdateTime).inMilliseconds > 200) {
          currentDistance.value = model.distance;
          isViolation.value = model.isViolation;
          lastUiUpdateTime = now;
        }

        _processGamification(model);
        _saveToLocal(model);
      }
    }, onError: (error) {
      _logger.e('Kesalahan Stream Telemetri: $error');
    });
  }

  void _processGamification(TelemetryModel model) {
    if (!model.isViolation) {
      _safeDistanceSeconds++;
      if (_safeDistanceSeconds >= 10) { 
        _rewardService.unlockSticker('s1');
      }
    } else {
      _safeDistanceSeconds = 0;
    }
  }

  void _saveToLocal(TelemetryModel model) async {
    await _telemetryBox.add(model.toJson());
    _logger.d('Data Lokal Tersimpan: ${model.distance.toStringAsFixed(2)} cm');

    if (_telemetryBox.length >= _batchThreshold) {
      _triggerSync();
    }
  }

  /// Perbaikan: Menambahkan kembali method yang hilang untuk Repository
  List<TelemetryModel> getAllLocalLogs() {
    return _telemetryBox.values
        .map((jsonStr) => TelemetryModel.fromJson(jsonStr))
        .toList();
  }

  TelemetryModel? getLatestData() {
    if (_telemetryBox.isEmpty) return null;
    return TelemetryModel.fromJson(_telemetryBox.values.last);
  }

  Future<void> _triggerSync() async {
    final List<TelemetryModel> batch = [];
    final List<int> keysToDelete = [];

    for (var i = 0; i < _telemetryBox.length; i++) {
      final key = _telemetryBox.keyAt(i);
      final jsonStr = _telemetryBox.get(key);
      batch.add(TelemetryModel.fromJson(jsonStr));
      keysToDelete.add(key);
    }

    final success = await _syncService.syncBatch(batch);
    if (success) {
      await _telemetryBox.deleteAll(keysToDelete);
      _logger.i('Cache Lokal dibersihkan: Sinkronisasi Cloud Berhasil.');
    }
  }
}
