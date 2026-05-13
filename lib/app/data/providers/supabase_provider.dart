import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:logger/logger.dart';

/// Layer Data Source untuk komunikasi langsung dengan Supabase API.
/// Memastikan standar HTTP dan pemanfaatan PostgREST berjalan optimal.
class SupabaseProvider {
  final SupabaseClient _client = Supabase.instance.client;
  final Logger _logger = Logger();

  /// Mendapatkan profil user yang sedang login beserta data anak (jika ada).
  Future<Map<String, dynamic>?> getCurrentUserProfile() async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) return null;

      final response = await _client
          .from('users')
          .select('*, children:users!parent_id(*)')
          .eq('id', user.id)
          .maybeSingle();

      return response;
    } on PostgrestException catch (e) {
      _logger.e('PostgREST Error [${e.code}]: ${e.message}');
      rethrow;
    } catch (e) {
      _logger.e('SupabaseProvider Exception: $e');
      rethrow;
    }
  }

  /// Sinkronisasi data perangkat untuk Multi-Device Management.
  Future<void> syncDevice(Map<String, dynamic> deviceData) async {
    try {
      await _client.from('devices').upsert(deviceData);
    } catch (e) {
      _logger.e('Device Sync Error: $e');
      rethrow;
    }
  }

  /// Mengirim data telemetri secara batch untuk efisiensi bandwidth.
  Future<void> insertTelemetryBatch(List<Map<String, dynamic>> batchData) async {
    if (batchData.isEmpty) return;
    try {
      await _client.from('telemetry_logs').insert(batchData);
      _logger.i('Telemetry Batch Synced: ${batchData.length} records.');
    } catch (e) {
      _logger.e('Telemetry Batch Sync Error: $e');
      rethrow;
    }
  }

  /// Real-time stream untuk data telemetri (khusus untuk Dashboard Orang Tua).
  Stream<List<Map<String, dynamic>>> listenToChildTelemetry(String childId) {
    return _client
        .from('telemetry_logs')
        .stream(primaryKey: ['id'])
        .eq('user_id', childId)
        .order('recorded_at')
        .limit(1);
  }
}
