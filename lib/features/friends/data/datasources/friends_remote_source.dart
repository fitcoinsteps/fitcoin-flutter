import 'package:dio/dio.dart';
import 'package:fitcoin/core/network/dio_client.dart';
import 'package:fitcoin/features/friends/data/models/friends_data_model.dart';
import 'package:fitcoin/features/friends/data/models/search_user_model.dart';
import 'package:fitcoin/features/friends/data/models/friend_request_model.dart';

class FriendsRemoteSource {
  final Dio _dio;

  FriendsRemoteSource() : _dio = DioClient().dio;

  Future<FriendsDataModel> getFriends() async {
    final response = await _dio.get('/friends');
    return FriendsDataModel.fromJson(response.data);
  }

  Future<List<SearchUserModel>> searchUsers(String query) async {
    final response = await _dio.get(
      '/users/search',
      queryParameters: {'query': query},
    );
    final data = response.data as Map<String, dynamic>;
    final users = data['users'] as List<dynamic>? ?? [];
    return users.map((item) => SearchUserModel.fromJson(item)).toList();
  }

  Future<void> sendFriendRequest(int receiverId) async {
    await _dio.post('/friends/request', data: {'receiver_id': receiverId});
  }

  Future<void> acceptFriendRequest(int friendshipId) async {
    await _dio.post('/friends/accept', data: {'friendship_id': friendshipId});
  }

  Future<void> rejectFriendRequest(int friendshipId) async {
    await _dio.post('/friends/reject', data: {'friendship_id': friendshipId});
  }

  Future<List<FriendRequestModel>> getPendingRequests() async {
    final response = await _dio.get('/friends/requests');
    final data = response.data as Map<String, dynamic>;
    final incoming = data['incoming'] as List<dynamic>? ?? [];
    final outgoing = data['outgoing'] as List<dynamic>? ?? [];
    final all = [
      ...incoming.map((e) => e as Map<String, dynamic>),
      ...outgoing.map((e) => e as Map<String, dynamic>),
    ];
    return all.map((item) => FriendRequestModel.fromJson(item)).toList();
  }

  Future<void> removeFriend(int friendId) async {
    await _dio.delete('/friends/$friendId');
  }
}