import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../logger/app_logger.dart';

class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage _storage;
  final Logger _logger;

  AuthInterceptor(this._storage, this._logger);

  @override
  Future<void> onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) async {
    // Skip auth header for public endpoints
    final publicPaths = ['/auth/login', '/auth/register', '/auth/refresh'];
    if (publicPaths.any((path) => options.path.contains(path))) {
      _logger.api('Skipping auth for public endpoint: ${options.path}');
      return handler.next(options);
    }

    try {
      final token = await _storage.read(key: 'access_token');
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
        _logger.api('🔑 Added auth token to request: ${options.path}');
      } else {
        _logger.api('⚠️ No auth token available for: ${options.path}');
      }
    } catch (e) {
      _logger.e('Error adding auth token: $e');
    }

    return handler.next(options);
  }
}