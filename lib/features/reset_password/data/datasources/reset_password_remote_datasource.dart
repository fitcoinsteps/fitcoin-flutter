import 'package:dio/dio.dart';
import 'package:fitcoin/core/network/dio_client.dart';

class ResetPasswordRemoteDataSource {
  final Dio dio;

  ResetPasswordRemoteDataSource() : dio = DioClient().dio;

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
        throw Exception(response.data['error'] ?? 'Failed to reset password');
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['error'] ?? e.response?.data['message'] ?? 'Failed to reset password',
      );
    }
  }
}