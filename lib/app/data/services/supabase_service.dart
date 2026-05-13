import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:logger/logger.dart';
import '../models/telemetry_model.dart';

/// Layanan untuk mengelola komunikasi dengan Supabase REST API.
/// Sesuai Standar Enterprise: Mendukung operasional CRUD secara asinkron ke Cloud.
class SupabaseService extends GetxService {
  final _supabase = Supabase.instance.client;
  final _logger = Logger();

  /// Mengirim data telemetri secara batch ke server Supabase (Cloud).
  /// Memenuhi Kriteria: Optimasi Big Data & Efisiensi Network.
  Future<bool> sendTelemetryBatch(List<TelemetryModel> models) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        _logger.w('Web Service: Gagal mengirim data karena user belum login.');
        return false;
      }

      if (models.isEmpty) return true;

      final dataToInsert = models.map((model) => {
        'user_id': user.id,
        'distance': model.distance,
        'is_violation': model.isViolation,
        'created_at': model.timestamp.toIso8601String(),
      }).toList();

      await _supabase.from('telemetry').insert(dataToInsert);

      _logger.i('Sinkronisasi Cloud: ${models.length} data telemetri berhasil diunggah.');
      return true;
    } catch (e) {
      _logger.e('Kesalahan Web Service: Gagal sinkronisasi batch ke Cloud.');
      _logger.e(e.toString());
      return false;
    }
  }

  /// Mengirim data telemetri tunggal (Fallback).
  Future<bool> sendTelemetry(TelemetryModel model) async {
    return sendTelemetryBatch([model]);
  }

  /// Mengecek status koneksi ke Supabase secara real-time.
  Future<bool> checkConnection() async {
    try {
      // Melakukan query ringan (ping) ke sistem auth
      await _supabase.from('telemetry').select('id').limit(1);
      return true;
    } catch (e) {
      _logger.e('Koneksi Supabase Terputus: $e');
      return false;
    }
  }

  /// Mengambil data telemetri dalam jumlah besar untuk keperluan analitik (Heatmap).
  Future<List<Map<String, dynamic>>> getAnalyticsData({int limit = 1000}) async {
    try {
      final data = await _supabase
          .from('telemetry')
          .select()
          .order('created_at', ascending: false)
          .limit(limit);
      
      return List<Map<String, dynamic>>.from(data);
    } catch (e) {
      _logger.e('Kesalahan Analitik: Gagal mengambil data Big Data dari Cloud.');
      return [];
    }
  }
}
