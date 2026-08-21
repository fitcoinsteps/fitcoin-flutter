import 'package:dio/dio.dart';
import 'package:fitcoin/core/network/dio_client.dart';
import 'package:fitcoin/core/cache/cache_service.dart';

class LogoutRemoteDataSource {
  final Dio dio;
  final CacheService cacheService;

  LogoutRemoteDataSource({required this.cacheService}) : dio = DioClient().dio;

  Future<String> logout() async {
    try {
      // ✅ Use static method
      final token = CacheService.getToken();

      final response = await dio.post(
        '/logout',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        CacheService.clearAll(); // ✅ Static method
        return response.data['message'] ?? 'Logged out successfully';
      } else {
        throw Exception(response.data['error'] ?? 'Logout failed');
      }
    } on DioException catch (e) {
      // Even if API fails, clear local cache
      CacheService.clearAll(); // ✅ Static method
      throw Exception(e.response?.data['error'] ?? 'Logout failed');
    }
  }

  Future<String> logoutAllDevices() async {
    try {
      // ✅ Use static method
      final token = CacheService.getToken();

      final response = await dio.post(
        '/logout-all',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        CacheService.clearAll(); // ✅ Static method
        return response.data['message'] ?? 'All sessions revoked successfully';
      } else {
        throw Exception(response.data['error'] ?? 'Logout failed');
      }
    } on DioException catch (e) {
      CacheService.clearAll(); // ✅ Static method
      throw Exception(e.response?.data['error'] ?? 'Logout failed');
    }
  }
}