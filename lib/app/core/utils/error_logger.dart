import 'package:logger/logger.dart';

class ErrorLogger {
  static final _logger = Logger();

  static void recordError(dynamic exception, StackTrace? stack) {
    _logger.e('CRASH REPORTING: $exception', error: exception, stackTrace: stack);
    // Di masa depan bisa ditambahkan integrasi ke Supabase atau Sentry di sini
  }
}
