import 'package:get/get.dart';
import '../models/telemetry_model.dart';
import 'auth_service.dart';
import 'supabase_service.dart';
import 'observability_service.dart';

/// Layanan untuk sinkronisasi data dari lokal ke Cloud Server.
/// Implementasi Standar Enterprise: Menggunakan delegasi ke SupabaseService.
class SyncService extends GetxService {
  final SupabaseService _supabaseService = Get.find<SupabaseService>();
  late final ObservabilityService _observability = Get.find<ObservabilityService>();

  /// Mengirim data telemetri secara batch dengan teknik sinkronisasi cloud.
  Future<SyncResult> syncBatch(List<TelemetryModel> batch) async {
    final authService = Get.find<AuthService>();
    
    if (batch.isEmpty) {
      return SyncResult.success;
    }

    // Pastikan user sudah terautentikasi sebelum sinkronisasi
    if (!authService.isLoggedIn.value) {
      _observability.log(
        severity: LogSeverity.warn,
        category: 'SYNC_SERVICE',
        message: 'Sync: User belum login. Penangguhan sinkronisasi telemetry.',
      );
      return SyncResult.transientError;
    }

    try {
      // Mengirimkan seluruh batch data telemetri ke Supabase
      // Sesuai mandat: Menjamin integritas data Big Data.
      final result = await _supabaseService.sendTelemetryBatch(batch);
      return result;
    } catch (e, stack) {
      _observability.log(
        severity: LogSeverity.error,
        category: 'SYNC_SERVICE_FAILED',
        message: 'Operasi Sync Gagal: Kesalahan sinkronisasi -> $e',
        error: e,
        stackTrace: stack,
      );
      return SyncResult.transientError;
    }
  }
}
