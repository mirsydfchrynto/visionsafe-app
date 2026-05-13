import 'package:get/get.dart';
import '../models/telemetry_model.dart';
import '../services/telemetry_service.dart';

/// Repository untuk akses data telemetri.
/// Memisahkan logika UI dari sumber data (Hive).
/// Matkul: Big Data & Software Architecture (Clean)
class TelemetryRepository {
  final TelemetryService _service = Get.find<TelemetryService>();

  /// Mengambil semua log telemetri yang belum disinkronkan.
  List<TelemetryModel> getLocalLogs() {
    return _service.getAllLocalLogs();
  }

  /// Menghitung total durasi pelanggaran hari ini (Menit).
  /// Logika: Tiap log mewakili SAMPLING_RATE_MS (misal 1.5 detik).
  double calculateViolationMinutesToday() {
    final now = DateTime.now();
    final logs = getLocalLogs().where((log) => 
      log.isViolation && 
      log.timestamp.day == now.day &&
      log.timestamp.month == now.month &&
      log.timestamp.year == now.year
    );

    // Asumsi tiap log = 1.0 detik (sesuai SAMPLING_RATE_MS baru di Native)
    return (logs.length * 1.0) / 60;
  }
}
