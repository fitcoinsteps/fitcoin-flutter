import 'package:fitcoin/features/friends/domain/entities/search_user.dart';

class SearchUserModel extends SearchUser {
  const SearchUserModel({
    required super.id,
    required super.name,
    required super.username,
    required super.avatarUrl,
    required super.isOnline,
  });

  factory SearchUserModel.fromJson(Map<String, dynamic> json) {
    return SearchUserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      username: json['username'] ?? '',
      avatarUrl: json['avatar_url'] as String?,
      isOnline: json['is_online'] ?? false,
    );
  }
}