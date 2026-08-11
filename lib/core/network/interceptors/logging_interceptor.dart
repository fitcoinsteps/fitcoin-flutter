import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class LoggingInterceptor extends Interceptor {
  final Logger _logger;

  LoggingInterceptor(this._logger);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _logger.api('''
┌─────────────────────────────────────────────────────
│ 📤 REQUEST: ${options.method} ${options.uri}
│ 📋 Headers: ${options.headers}
│ 📦 Data: ${options.data}
└─────────────────────────────────────────────────────''');
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _logger.api('''
┌─────────────────────────────────────────────────────
│ 📥 RESPONSE: ${response.statusCode} ${response.requestOptions.path}
│ 📦 Data: ${response.data}
└─────────────────────────────────────────────────────''');
    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _logger.e('''
┌─────────────────────────────────────────────────────
│ ❌ ERROR: ${err.response?.statusCode} ${err.requestOptions.path}
│ 📋 Message: ${err.message}
│ 📦 Response: ${err.response?.data}
└─────────────────────────────────────────────────────''');
    return handler.next(err);
  }
}