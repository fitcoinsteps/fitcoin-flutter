import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dio_smart_refresh/dio_smart_refresh.dart';
import '../config/app_config.dart';
import '../logger/app_logger.dart';
import '../cache/cache_service.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/logging_interceptor.dart';

final dioClientProvider = Provider<Dio>((ref) {
  final config = ref.watch(appConfigProvider);
  final logger = ref.watch(loggerProvider);
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
  dio.interceptors.add(AuthInterceptor(storage, logger));

  // Add smart refresh interceptor
  dio.interceptors.add(
    SmartRefreshInterceptor(
      dio: dio,
      tokenStorage: storage,
      config: SmartRefreshConfig(
        refreshPath: '/auth/refresh',
        maxAttempts: 3,
        proactiveMargin: const Duration(minutes: 8),
        tokenExpirationGracePeriod: const Duration(seconds: 30),
        allowRefreshWhenUnauthorized: true,
        enableProactiveRefresh: true,
        refreshTokenParseFunction: (response) {
          return response.data['access_token'] as String?;
        },
      ),
      onTokenRefreshed: (newToken) async {
        logger.auth('🔄 Token refreshed successfully');
        await storage.write(key: 'access_token', value: newToken);
        // Update cache if needed
        final cache = ref.read(cacheServiceProvider);
        cache.cacheToken(newToken);
      },
      onAuthFailed: () {
        logger.auth('❌ Authentication failed - redirecting to login');
        // Navigate to login page
        // Use go_router to redirect
      },
    ),
  );

  return dio;
});