import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:fitcoin/core/config/app_config.dart';
import 'package:fitcoin/core/cache/cache_service.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  late final Dio dio;

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

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = CacheService.getToken();

          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          return handler.next(options);
        },
      ),
    );

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

    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (e, handler) async {
          if (e.type == DioExceptionType.connectionTimeout ||
              e.type == DioExceptionType.receiveTimeout) {
            return handler.next(
              DioException(
                requestOptions: e.requestOptions,
                error: 'Connection timeout. Please check your internet.',
                type: DioExceptionType.connectionTimeout,
              ),
            );
          }

          if (e.response?.statusCode == 401) {
            CacheService.clearAll();
          }

          return handler.next(e);
        },
      ),
    );
  }
}