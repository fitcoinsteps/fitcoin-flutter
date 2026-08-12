import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class LoggingInterceptor extends Interceptor {
  final Logger _logger;

  LoggingInterceptor(this._logger);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _logger.d('''
┌─────────────────────────────────────────────────────
│ 📤 REQUEST: ${options.method} ${options.uri}
│ 📋 Headers: ${options.headers}
│ 📦 Data: ${options.data}
└─────────────────────────────────────────────────────''');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _logger.d('''
┌─────────────────────────────────────────────────────
│ 📥 RESPONSE: ${response.statusCode} ${response.requestOptions.path}
│ 📦 Data: ${response.data}
└─────────────────────────────────────────────────────''');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _logger.e('''
┌─────────────────────────────────────────────────────
│ ❌ ERROR: ${err.response?.statusCode} ${err.requestOptions.path}
│ 📋 Message: ${err.message}
│ 📦 Response: ${err.response?.data}
└─────────────────────────────────────────────────────''');
    handler.next(err);
  }
}