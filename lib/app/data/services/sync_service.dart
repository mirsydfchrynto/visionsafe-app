import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../models/telemetry_model.dart';
import 'auth_service.dart';
import 'supabase_service.dart';

/// Layanan untuk sinkronisasi data dari lokal ke Cloud Server.
/// Implementasi Standar Enterprise: Menggunakan delegasi ke SupabaseService.
class SyncService extends GetxService {
  final _logger = Logger();
  
  // Dependensi SupabaseService untuk komunikasi Cloud
  final SupabaseService _supabaseService = Get.find<SupabaseService>();

  /// Mengirim data telemetri secara batch dengan teknik sinkronisasi cloud.
  Future<bool> syncBatch(List<TelemetryModel> batch) async {
    final authService = Get.find<AuthService>();
    
    // Pastikan user sudah terautentikasi sebelum sinkronisasi
    if (batch.isEmpty || !authService.isLoggedIn.value) {
      return true;
    }

    try {
      // Mengirimkan seluruh batch data telemetri ke Supabase
      // Sesuai mandat: Menjamin integritas data Big Data.
      await _supabaseService.sendTelemetryBatch(batch);
      
      _logger.i('Operasi Sync Berhasil: ${batch.length} data terkirim ke Cloud.');
      return true;
    } catch (e) {
      _logger.e('Operasi Sync Gagal: Kesalahan sinkronisasi -> $e');
      return false;
    }
  }
}
