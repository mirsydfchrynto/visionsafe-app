import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:visionsafe/app/data/models/telemetry_model.dart';
import 'package:visionsafe/app/data/services/auth_service.dart';

/// Layanan untuk berkomunikasi dengan Custom Kotlin Ktor Backend.
/// Digunakan untuk memenuhi kriteria UTS "Web Service Integration".
class BackendApiService extends GetxService {
  // Alamat default untuk Emulator. 
  // Gunakan setBaseUrl() untuk mengganti secara dinamis jika pakai HP Fisik.
  String _baseUrl = 'http://10.0.2.2:8080/api/v1'; 
  final Logger _logger = Logger();
  final AuthService _authService = Get.find<AuthService>();

  /// Mengganti Base URL secara dinamis (Misal: ke IP Lokal Laptop).
  void setBaseUrl(String ip) {
    if (ip.startsWith('http')) {
      _baseUrl = ip;
    } else {
      _baseUrl = 'http://$ip:8080/api/v1';
    }
    _logger.i('Ktor Base URL diupdate ke: $_baseUrl');
  }

  String get baseUrl => _baseUrl;

  /// Mengirim data telemetri ke Kotlin Ktor Backend.
  Future<bool> syncToKtor(List<TelemetryModel> batch) async {
    if (batch.isEmpty) return true;

    try {
      final token = _authService.accessToken;
      if (token == null) return false;

      final response = await http.post(
        Uri.parse('$_baseUrl/telemetry/batch'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(batch.map((e) => e.toMap()).toList()),
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 201) {
        _logger.i('Ktor Backend Sync Success: ${batch.length} logs.');
        return true;
      } else {
        _logger.e('Ktor Backend Sync Failed: ${response.statusCode} - ${response.body}');
        return false;
      }
    } on SocketException {
      _logger.w('Ktor Backend Offline: Gagal terhubung ke $_baseUrl. Pastikan server Ktor jalan dan IP benar.');
      return false;
    } on Exception catch (e) {
      _logger.e('BackendApiService unexpected error: $e');
      return false;
    }
  }
}
