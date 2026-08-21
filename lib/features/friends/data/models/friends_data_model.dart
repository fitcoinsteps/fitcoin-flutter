import 'package:fitcoin/features/friends/domain/entities/friends_data.dart';
import 'friend_model.dart';

class FriendsDataModel extends FriendsData {
  const FriendsDataModel({
    required super.totalUsers,
    required super.friends,
  });

  factory FriendsDataModel.fromJson(Map<String, dynamic> json) {
    return FriendsDataModel(
      totalUsers: json['total_users'] ?? 0,
      friends: (json['friends'] as List<dynamic>? ?? [])
          .map((item) => FriendModel.fromJson(item))
          .toList(),
    );
  }
}