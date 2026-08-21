import 'package:dio/dio.dart';
import 'package:fitcoin/core/network/dio_client.dart';
import 'package:fitcoin/core/cache/cache_service.dart';
import 'package:fitcoin/features/login_auth/domain/models/login_response.dart';
import 'package:fitcoin/features/login_auth/data/models/login_request_model.dart';

class LoginRemoteDataSource {
  final Dio dio;
  final CacheService cacheService;

  LoginRemoteDataSource({required this.cacheService}) : dio = DioClient().dio;

  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await dio.post('/login', data: request.toJson());

      if (response.statusCode == 200) {
        final loginResponse = LoginResponse.fromJson(response.data);

        CacheService.cacheToken(loginResponse.accessToken);
        CacheService.cacheRefreshToken(loginResponse.refreshToken);
        CacheService.cacheTokenExpiry(loginResponse.expiresIn);

        return loginResponse;
      } else {
        throw Exception(
          response.data['error'] ?? response.data['message'] ?? 'Login failed',
        );
      }
    } on DioException catch (e) {
      throw Exception(_mapDioErrorToUserMessage(e));
    }
  }

  String _mapDioErrorToUserMessage(DioException e) {
    final statusCode = e.response?.statusCode;

    if (statusCode == 403) {
      final backendError = e.response?.data['error'] ?? '';
      if (backendError == 'This account type is not allowed to use this login method.') {
        return 'Permission denied';   // very short message
      }
      return 'Access denied';
    }

    final data = e.response?.data;
    if (data is Map && data.containsKey('error')) {
      return data['error'] as String;
    }
    if (data is Map && data.containsKey('message')) {
      return data['message'] as String;
    }
    return 'Login failed';
  }
}