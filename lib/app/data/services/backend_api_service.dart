import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:visionsafe/app/data/models/telemetry_model.dart';
import 'package:visionsafe/app/data/services/auth_service.dart';

/// Layanan untuk berkomunikasi dengan Custom Kotlin Ktor Backend.
/// Migrasi ke Dio (Enterprise Standard) untuk konsolidasi HTTP Client.
class BackendApiService extends GetxService {
  String _baseUrl = 'http://10.0.2.2:8080/api/v1'; 
  final Logger _logger = Logger();
  final AuthService _authService = Get.find<AuthService>();
  late final Dio _dio;

  @override
  void onInit() {
    super.onInit();
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
    ));
    
    // Add Token Interceptor
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        final token = _authService.accessToken;
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
    ));
  }

  void setBaseUrl(String ip) {
    if (ip.startsWith('http')) {
      _baseUrl = ip;
    } else {
      _baseUrl = 'http://$ip:8080/api/v1';
    }
    _dio.options.baseUrl = _baseUrl;
    _logger.i('Ktor Base URL diupdate ke: $_baseUrl');
  }

  String get baseUrl => _baseUrl;

  Future<bool> syncToKtor(List<TelemetryModel> batch) async {
    if (batch.isEmpty) return true;

    try {
      final response = await _dio.post(
        '/telemetry/batch',
        data: batch.map((e) => e.toMap()).toList(),
      );

      if (response.statusCode == 201) {
        _logger.i('Ktor Backend Sync Success: ${batch.length} logs.');
        return true;
      }
      return false;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError || e.error is SocketException) {
        _logger.w('Ktor Backend Offline: Gagal terhubung ke $_baseUrl.');
      } else {
        _logger.e('Ktor Backend Sync Failed: ${e.response?.statusCode} - ${e.message}');
      }
      return false;
    }
  }
}
