import 'package:logger/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/app_config.dart';

final loggerProvider = Provider<Logger>((ref) {
  final config = ref.watch(appConfigProvider);

  return Logger(
    level: config.debugMode ? Level.debug : Level.info,
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      printTime: true,
    ),
  );
});

// Convenience extension for quick logging
extension LoggerExtension on Logger {
  void api(String message) {
    d('🌐 API: $message');
  }

  void auth(String message) {
    d('🔐 AUTH: $message');
  }

  void payment(String message) {
    d('💳 PAYMENT: $message');
  }

  void booking(String message) {
    d('📅 BOOKING: $message');
  }

  void db(String message) {
    d('💾 DB: $message');
  }
}