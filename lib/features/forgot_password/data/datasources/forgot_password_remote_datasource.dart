import 'package:dio/dio.dart';
import 'package:fitcoin/core/network/dio_client.dart';

class ForgotPasswordRemoteDataSource {
  final Dio dio;

  ForgotPasswordRemoteDataSource() : dio = DioClient().dio;

  Future<String> sendResetOtp(String email) async {
    try {
      final response = await dio.post(
        '/forgot-password',
        data: {'email': email},
      );

      if (response.statusCode == 200) {
        return response.data['message'] ?? 'OTP sent to your email';
      } else {
        throw Exception(response.data['message'] ?? 'Failed to send OTP');
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Failed to send OTP',
      );
    }
  }

  Future<String> verifyResetOtp({
    required String email,
    required String code,
  }) async {
    try {
      final response = await dio.post(
        '/verify-token',
        data: {'email': email, 'code': code},
      );

      if (response.statusCode == 200) {
        return response.data['token'] ?? '';
      } else {
        throw Exception(response.data['message'] ?? 'Invalid OTP');
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Invalid OTP',
      );
    }
  }
}