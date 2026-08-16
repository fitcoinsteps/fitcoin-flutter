import 'package:dio/dio.dart';
import 'package:fitcoin/core/network/dio_client.dart';
import 'package:fitcoin/core/cache/cache_service.dart';

class LogoutRemoteDataSource {
  final Dio dio;
  final CacheService cacheService;

  LogoutRemoteDataSource({required this.cacheService}) : dio = DioClient().dio;

  Future<String> logout() async {
    try {
      final token = cacheService.getCachedToken();

      final response = await dio.post(
        '/logout',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        cacheService.logout(); // ✅ No await - it's void
        return response.data['message'] ?? 'Logged out successfully';
      } else {
        throw Exception(response.data['error'] ?? 'Logout failed');
      }
    } on DioException catch (e) {
      // Even if API fails, clear local cache
      cacheService.logout(); // ✅ No await - it's void
      throw Exception(e.response?.data['error'] ?? 'Logout failed');
    }
  }

  Future<String> logoutAllDevices() async {
    try {
      final token = cacheService.getCachedToken();

      final response = await dio.post(
        '/logout-all',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        cacheService.logout(); // ✅ No await - it's void
        return response.data['message'] ?? 'All sessions revoked successfully';
      } else {
        throw Exception(response.data['error'] ?? 'Logout failed');
      }
    } on DioException catch (e) {
      cacheService.logout(); // ✅ No await - it's void
      throw Exception(e.response?.data['error'] ?? 'Logout failed');
    }
  }
}