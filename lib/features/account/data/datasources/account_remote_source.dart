import 'package:dio/dio.dart';
import 'package:fitcoin/core/network/dio_client.dart';

class AccountRemoteSource {
  final Dio _dio;

  AccountRemoteSource() : _dio = DioClient().dio;

  Future<void> deactivateAccount({required String password}) async {
    await _dio.post(
      '/account/deactivate',
      data: {'password': password},
    );
  }
}