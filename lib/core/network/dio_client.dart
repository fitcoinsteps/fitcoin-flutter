import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:fitcoin/core/config/app_config.dart';
import 'package:fitcoin/core/cache/cache_service.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  late final Dio dio;
  static bool _isRefreshing = false;
  static final List<RequestOptions> _failedRequests = [];

  factory DioClient() => _instance;

  DioClient._internal() {
    final config = AppConfig.current;

    dio = Dio(
      BaseOptions(
        baseUrl: config.apiBaseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    // ==================== REQUEST INTERCEPTOR ====================
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Skip adding token for refresh endpoint (it uses refresh_token in body)
          if (options.path.contains('/refresh')) {
            return handler.next(options);
          }

          final token = CacheService.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );

    // ==================== RESPONSE INTERCEPTOR ====================
    dio.interceptors.add(
      InterceptorsWrapper(
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (error, handler) async {
          // Skip refresh for login, register, verify-otp endpoints
          final skipPaths = ['/login', '/register', '/verify-otp'];
          if (skipPaths.any((path) => error.requestOptions.path.contains(path))) {
            return handler.next(error);
          }

          // Handle /refresh endpoint specifically
          if (error.requestOptions.path.contains('/refresh')) {
            if (error.response?.statusCode == 401) {
              // Refresh token expired - logout
              await _logout();
            }
            return handler.next(error);
          }

          // Handle 401 - Token expired
          if (error.response?.statusCode == 401) {
            if (!_isRefreshing) {
              _isRefreshing = true;

              try {
                final newToken = await _refreshToken();

                if (newToken != null) {
                  // Save new token
                  CacheService.cacheToken(newToken);

                  // Retry all failed requests
                  for (final request in _failedRequests) {
                    request.headers['Authorization'] = 'Bearer $newToken';
                    try {
                      await dio.fetch(request);
                    } catch (_) {}
                  }
                  _failedRequests.clear();

                  // Retry the original request
                  final options = error.requestOptions;
                  options.headers['Authorization'] = 'Bearer $newToken';
                  final response = await dio.fetch(options);
                  return handler.resolve(response);
                } else {
                  // Refresh failed - logout
                  await _logout();
                }
              } catch (_) {
                await _logout();
              } finally {
                _isRefreshing = false;
              }
            } else {
              // If refreshing, queue the request
              _failedRequests.add(error.requestOptions);
              return handler.next(error);
            }
          }

          return handler.next(error);
        },
      ),
    );

    // ==================== LOGGING INTERCEPTOR ====================
    if (config.debugMode && config.enableLogging) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
          responseBody: true,
          error: true,
          compact: false,
          maxWidth: 90,
        ),
      );
    }
  }

  // ==================== REFRESH TOKEN ====================
  Future<String?> _refreshToken() async {
    final refreshToken = CacheService.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      print('❌ No refresh token available');
      return null;
    }

    try {
      print('🔄 Refreshing token...');

      // Create a new Dio instance for refresh to avoid interceptor conflicts
      final refreshDio = Dio(
        BaseOptions(
          baseUrl: AppConfig.current.apiBaseUrl,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );

      final response = await refreshDio.post(
        '/refresh',
        data: {'refresh_token': refreshToken},
      );

      if (response.statusCode == 200) {
        final newAccessToken = response.data['access_token'];
        final expiresIn = response.data['expires_in'] ?? 3600;

        if (newAccessToken != null && newAccessToken.isNotEmpty) {
          CacheService.cacheToken(newAccessToken);
          CacheService.cacheTokenExpiry(expiresIn);

          // If backend returns a new refresh token, cache it as well
          if (response.data['refresh_token'] != null) {
            CacheService.cacheRefreshToken(response.data['refresh_token']);
          }

          print('✅ Token refreshed successfully');
          return newAccessToken;
        }
      }

      print('❌ Refresh failed: ${response.statusCode}');
      return null;
    } catch (e) {
      print('❌ Refresh error: $e');
      return null;
    }
  }

  // ==================== LOGOUT ====================
  Future<void> _logout() async {
    print('🔴 Logging out - clearing all tokens');
    CacheService.clearAll();
    // You can navigate to login screen here using a global navigator key
  }
}