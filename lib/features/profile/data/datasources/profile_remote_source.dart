import 'package:dio/dio.dart';
import 'package:fitcoin/core/network/dio_client.dart';
import 'package:fitcoin/features/profile/data/models/user_profile_model.dart';

class ProfileRemoteSource {
  final Dio _dio;

  ProfileRemoteSource() : _dio = DioClient().dio;

  Future<UserProfileModel> getProfile() async {
    final response = await _dio.get('/profile');
    return UserProfileModel.fromJson(response.data);
  }

  Future<UserProfileModel> updateProfile({
    String? firstName,
    String? lastName,
    String? username,
    String? phone,
  }) async {
    final data = <String, dynamic>{};
    if (firstName != null) data['first_name'] = firstName;
    if (lastName != null) data['last_name'] = lastName;
    if (username != null) data['username'] = username;
    if (phone != null) data['phone'] = phone;

    final response = await _dio.post('/profile/update', data: data);
    return UserProfileModel.fromJson(response.data['profile']);
  }

  Future<UserProfileModel> uploadAvatar(String filePath) async {
    final formData = FormData.fromMap({
      'avatar': await MultipartFile.fromFile(filePath),
    });
    final response = await _dio.post('/profile/avatar', data: formData);
    return UserProfileModel.fromJson(response.data['profile']);
  }
}