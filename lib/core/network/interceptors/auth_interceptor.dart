import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';

class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage _storage;
  final Logger _logger;
  String? _cachedToken;

  AuthInterceptor(this._storage, this._logger);

  void updateToken(String token) {
    _cachedToken = token;
    _logger.i('🔑 Auth token updated in interceptor');
  }

  void clearToken() {
    _cachedToken = null;
    _logger.i('🔑 Auth token cleared from interceptor');
  }

  @override
  Future<void> onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) async {
    // Skip auth header for public endpoints
    final publicPaths = ['/auth/login', '/auth/register', '/auth/refresh'];
    if (publicPaths.any((path) => options.path.contains(path))) {
      _logger.d('Skipping auth for public endpoint: ${options.path}');
      return handler.next(options);
    }

    try {
      // Use cached token if available, otherwise read from storage
      String? token = _cachedToken;
      if (token == null) {
        token = await _storage.read(key: 'access_token');
        if (token != null) {
          _cachedToken = token;
        }
      }

      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
        _logger.d('🔑 Added auth token to request: ${options.path}');
      } else {
        _logger.d('⚠️ No auth token available for: ${options.path}');
      }
    } catch (e) {
      _logger.e('Error adding auth token: $e');
    }

    return handler.next(options);
  }
}