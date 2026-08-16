import 'package:dio/dio.dart';
import 'package:fitcoin/core/network/dio_client.dart';
import 'package:fitcoin/core/cache/cache_service.dart';
import 'package:fitcoin/features/auth/domain/models/registration_response.dart';
import 'package:fitcoin/features/auth/data/models/register_request_model.dart';
import 'package:fitcoin/features/auth/data/models/user_model.dart';
import 'package:fitcoin/features/auth/data/mappers/user_mapper.dart';

class AuthRemoteDataSource {
  final Dio dio;
  final CacheService cacheService;

  AuthRemoteDataSource({required this.cacheService}) : dio = DioClient().dio;

  Future<RegistrationResponse> register(RegisterRequest request) async {
    try {
      final response = await dio.post('/register', data: request.toJson());

      if (response.statusCode == 200) {
        return RegistrationResponse.fromJson(response.data);
      } else {
        throw Exception(response.data['message'] ?? 'Registration failed');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final message =
            e.response?.data['message'] ??
                e.response?.data['error'] ??
                'Registration failed';
        throw Exception(message);
      }
      throw Exception('Network error: ${e.message}');
    }
  }

  Future<UserModel> verifyOtp({
    required String email,
    required String code, // ✅ Changed from 'otp' to 'code'
  }) async {
    try {
      final response = await dio.post(
        '/verify-otp',
        data: {'email': email, 'code': code}, // ✅ Send 'code' not 'otp'
      );

      if (response.statusCode == 200) {
        final userData = response.data['user'] ?? {};
        final userModel = UserModel.fromJson(userData);

        final userEntity = UserMapper.toEntity(userModel);
        cacheService.cacheUserEntity(userEntity);

        cacheService.cacheUser(userModel.toJson());

        if (response.data['token'] != null) {
          cacheService.cacheToken(response.data['token']);
        }

        return userModel;
      } else {
        throw Exception(response.data['message'] ?? 'OTP verification failed');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Verification failed');
    }
  }

  Future<String> resendOtp({required String email}) async {
    try {
      final response = await dio.post('/resend-otp', data: {'email': email});

      if (response.statusCode == 200) {
        return response.data['message'] ?? 'OTP resent successfully';
      } else {
        throw Exception(response.data['message'] ?? 'Failed to resend OTP');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to resend OTP');
    }
  }

  Future<void> logout() async {
    cacheService.logout();
  }

  bool isAuthenticated() {
    return cacheService.getCachedToken() != null;
  }
}