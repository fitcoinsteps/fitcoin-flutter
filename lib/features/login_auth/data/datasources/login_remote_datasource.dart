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

        // Cache token - remove await if cacheToken is void
        cacheService.cacheToken(loginResponse.accessToken);

        return loginResponse;
      } else {
        throw Exception(
          response.data['error'] ?? response.data['message'] ?? 'Login failed',
        );
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['error'] ??
            e.response?.data['message'] ??
            'Login failed',
      );
    }
  }
}