import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import '../config/app_config.dart';
import '../logger/app_logger.dart'; // Import this for loggerProvider
import '../cache/cache_service.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/logging_interceptor.dart';

// Define the provider for AppConfig if not already defined
final appConfigProvider = Provider<AppConfig>((ref) {
  return AppConfig.development;
});

// Note: loggerProvider is now defined in app_logger.dart

final dioClientProvider = Provider<Dio>((ref) {
  final config = ref.watch(appConfigProvider);
  final logger = ref.watch(loggerProvider); // Now this will work
  final storage = const FlutterSecureStorage();

  final dio = Dio(
    BaseOptions(
      baseUrl: config.apiBaseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      contentType: 'application/json',
    ),
  );

  // Add logging interceptor
  if (config.enableLogging) {
    dio.interceptors.add(LoggingInterceptor(logger));
  }

  // Add auth interceptor
  final authInterceptor = AuthInterceptor(storage, logger);
  dio.interceptors.add(authInterceptor);

  // Add token refresh interceptor
  dio.interceptors.add(
    InterceptorsWrapper(
      onError: (DioException err, ErrorInterceptorHandler handler) async {
        // Only handle 401 errors
        if (err.response?.statusCode == 401) {
          try {
            // Try to get refresh token
            final refreshToken = await storage.read(key: 'refresh_token');

            if (refreshToken != null && refreshToken.isNotEmpty) {
              logger.i('🔄 Attempting to refresh token...');

              // Make refresh request
              final refreshResponse = await dio.post(
                '/auth/refresh',
                data: {'refresh_token': refreshToken},
                options: Options(
                  headers: {
                    'Content-Type': 'application/json',
                  },
                ),
              );

              final newToken = refreshResponse.data['access_token'] as String?;

              if (newToken != null && newToken.isNotEmpty) {
                logger.i('✅ Token refreshed successfully');

                // Save new token
                await storage.write(key: 'access_token', value: newToken);
                // Update auth interceptor with new token
                authInterceptor.updateToken(newToken);

                // Update cache
                final cache = ref.read(cacheServiceProvider);
                cache.cacheToken(newToken);

                // Retry the original request with new token
                final requestOptions = err.requestOptions;
                final newHeaders = Map<String, String>.from(requestOptions.headers);
                newHeaders['Authorization'] = 'Bearer $newToken';

                final retryResponse = await dio.request(
                  requestOptions.path,
                  options: Options(
                    method: requestOptions.method,
                    headers: newHeaders,
                  ),
                  data: requestOptions.data,
                  queryParameters: requestOptions.queryParameters,
                );

                return handler.resolve(retryResponse);
              }
            } else {
              logger.w('❌ No refresh token available');
              // Clear tokens and redirect to login
              await storage.delete(key: 'access_token');
              await storage.delete(key: 'refresh_token');
              authInterceptor.clearToken();
            }
          } catch (e) {
            logger.e('❌ Token refresh failed: $e');
            // Clear tokens on error
            await storage.delete(key: 'access_token');
            await storage.delete(key: 'refresh_token');
            authInterceptor.clearToken();
          }
        }

        // If refresh fails, pass the error
        handler.next(err);
      },
    ),
  );

  return dio;
});