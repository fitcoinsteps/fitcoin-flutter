import 'package:dio/dio.dart';
import 'package:fitcoin/core/network/dio_client.dart';
import 'package:fitcoin/core/cache/cache_service.dart';
import 'package:fitcoin/features/auth/domain/models/registration_response.dart';
import 'package:fitcoin/features/auth/data/models/register_request_model.dart';
import 'package:fitcoin/features/auth/data/models/user_model.dart';
import 'package:fitcoin/features/auth/data/mappers/user_mapper.dart';
import 'package:fitcoin/features/auth/presentation/states/auth_states.dart'; // ✅ for OtpVerificationResult

class AuthRemoteDataSource {
  final Dio dio;
  final CacheService cacheService;

  AuthRemoteDataSource({required this.cacheService})
      : dio = DioClient().dio;

  // ==================== REGISTER ====================
  Future<RegistrationResponse> register(RegisterRequest request) async {
    try {
      final response = await dio.post('/register', data: request.toJson());

      if (response.statusCode == 200 || response.statusCode == 201) {
        return RegistrationResponse.fromJson(response.data);
      } else {
        throw Exception(response.data['message'] ?? 'Registration failed');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final message = e.response?.data['message'] ??
            e.response?.data['error'] ??
            'Registration failed';
        throw Exception(message);
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  // ==================== VERIFY OTP ====================
  Future<OtpVerificationResult> verifyOtp({
    required String email,
    required String code,
  }) async {
    try {
      final response = await dio.post(
        '/verify-otp',
        data: {'email': email, 'code': code},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // ✅ Extract user
        final userData = response.data['user'] ?? {};
        final userModel = UserModel.fromJson(userData);
        final userEntity = UserMapper.toEntity(userModel);

        // ✅ Extract tokens
        final accessToken = response.data['access_token'] ?? '';
        final refreshToken = response.data['refresh_token'] ?? '';
        final expiresIn = response.data['expires_in'] ?? 3600;

        // ✅ Cache user (instance methods)
        cacheService.cacheUserEntity(userEntity);
        cacheService.cacheUser(userModel.toJson());

        // ✅ Cache tokens (static methods)
        if (accessToken.isNotEmpty) {
          CacheService.cacheToken(accessToken);
        }
        if (refreshToken.isNotEmpty) {
          CacheService.cacheRefreshToken(refreshToken);
        }
        CacheService.cacheTokenExpiry(expiresIn);

        return OtpVerificationResult(
          user: userEntity,
          accessToken: accessToken,
          refreshToken: refreshToken,
          expiresIn: expiresIn,
        );
      } else {
        throw Exception(response.data['message'] ?? 'OTP verification failed');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Verification failed');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  // ==================== RESEND OTP ====================
  Future<String> resendOtp({required String email}) async {
    try {
      final response = await dio.post('/resend-otp', data: {'email': email});

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data['message'] ?? 'OTP resent successfully';
      } else {
        throw Exception(response.data['message'] ?? 'Failed to resend OTP');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to resend OTP');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  // ==================== LOGOUT ====================
  Future<void> logout() async {
    try {
      final token = CacheService.getToken();
      if (token != null && token.isNotEmpty) {
        await dio.post(
          '/logout',
          options: Options(
            headers: {'Authorization': 'Bearer $token'},
          ),
        );
      }
    } catch (_) {
      // Ignore errors on logout
    } finally {
      CacheService.clearAll();
    }
  }

  // ==================== CHECK AUTHENTICATION ====================
  bool isAuthenticated() {
    final token = CacheService.getToken();
    if (token == null || token.isEmpty) return false;
    if (CacheService.isTokenExpired()) return false;
    return true;
  }

  // ==================== REFRESH TOKEN ====================
  Future<String?> refreshToken() async {
    try {
      final token = CacheService.getToken();
      if (token == null || token.isEmpty) return null;

      final response = await dio.post(
        '/refresh',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        final newToken = response.data['access_token'];
        final expiresIn = response.data['expires_in'] ?? 3600;
        if (newToken != null && newToken.isNotEmpty) {
          CacheService.cacheToken(newToken);
          CacheService.cacheTokenExpiry(expiresIn);
          return newToken;
        }
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  // ==================== GET CURRENT USER ====================
  Future<UserModel?> getCurrentUser() async {
    try {
      final token = CacheService.getToken();
      if (token == null || token.isEmpty) return null;

      final response = await dio.get(
        '/me',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        final userData = response.data['user'] ?? response.data;
        return UserModel.fromJson(userData);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  // ==================== UPDATE PROFILE ====================
  Future<UserModel> updateProfile(Map<String, dynamic> data) async {
    try {
      final token = CacheService.getToken();
      if (token == null || token.isEmpty) throw Exception('Not authenticated');

      final response = await dio.put(
        '/profile',
        data: data,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        final userData = response.data['user'] ?? response.data;
        final userModel = UserModel.fromJson(userData);
        final userEntity = UserMapper.toEntity(userModel);
        cacheService.cacheUserEntity(userEntity);
        cacheService.cacheUser(userModel.toJson());
        return userModel;
      } else {
        throw Exception(response.data['message'] ?? 'Profile update failed');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Profile update failed');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  // ==================== CHANGE PASSWORD ====================
  Future<String> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    try {
      final token = CacheService.getToken();
      if (token == null || token.isEmpty) throw Exception('Not authenticated');

      final response = await dio.post(
        '/change-password',
        data: {
          'current_password': currentPassword,
          'new_password': newPassword,
          'new_password_confirmation': newPasswordConfirmation,
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        return response.data['message'] ?? 'Password changed successfully';
      } else {
        throw Exception(response.data['message'] ?? 'Password change failed');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Password change failed');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  // ==================== FORGOT PASSWORD ====================
  Future<String> forgotPassword({required String email}) async {
    try {
      final response = await dio.post(
        '/forgot-password',
        data: {'email': email},
      );
      if (response.statusCode == 200) {
        return response.data['message'] ?? 'Reset link sent to your email';
      } else {
        throw Exception(response.data['message'] ?? 'Failed to send reset link');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to send reset link');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  // ==================== RESET PASSWORD ====================
  Future<String> resetPassword({
    required String email,
    required String token,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await dio.post(
        '/reset-password',
        data: {
          'email': email,
          'token': token,
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
      );
      if (response.statusCode == 200) {
        return response.data['message'] ?? 'Password reset successfully';
      } else {
        throw Exception(response.data['message'] ?? 'Password reset failed');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Password reset failed');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  // ==================== DELETE ACCOUNT ====================
  Future<String> deleteAccount() async {
    try {
      final token = CacheService.getToken();
      if (token == null || token.isEmpty) throw Exception('Not authenticated');

      final response = await dio.delete(
        '/account',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        CacheService.clearAll();
        return response.data['message'] ?? 'Account deleted successfully';
      } else {
        throw Exception(response.data['message'] ?? 'Account deletion failed');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Account deletion failed');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}