import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

final loggerProvider = Provider<Logger>((ref) {
  return Logger(
    level: Level.debug,
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );
});

final Logger appLogger = Logger(
  level: Level.debug,
  printer: PrettyPrinter(
    methodCount: 0,
    errorMethodCount: 5,
    lineLength: 120,
    colors: true,
    printEmojis: true,
    dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
  ),
);

extension LoggerExtensions on Logger {
  void db(String message) {
    d('[DB] $message');
  }

  void api(String message) {
    d('[API] $message');
  }

  void auth(String message) {
    d('[AUTH] $message');
  }

  void cache(String message) {
    d('[CACHE] $message');
  }

  void network(String message) {
    d('[NETWORK] $message');
  }
}