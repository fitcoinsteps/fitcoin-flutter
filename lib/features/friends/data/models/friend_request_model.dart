import 'package:fitcoin/features/friends/domain/entities/friend_request.dart';

class FriendRequestModel extends FriendRequest {
  const FriendRequestModel({
    required super.friendshipId,
    required super.senderId,
    required super.senderName,
    required super.senderUsername,
    required super.senderAvatarUrl,
    required super.receiverId,
    required super.receiverName,
    required super.receiverUsername,
    required super.receiverAvatarUrl,
    required super.createdAt,
  });

  factory FriendRequestModel.fromJson(Map<String, dynamic> json) {
    return FriendRequestModel(
      friendshipId: json['friendship_id'] ?? 0,
      senderId: json['sender']?['id'] ?? 0,
      senderName: json['sender']?['name'] ?? '',
      senderUsername: json['sender']?['username'] ?? '',
      senderAvatarUrl: json['sender']?['avatar_url'] as String?,
      receiverId: json['receiver']?['id'] ?? 0,
      receiverName: json['receiver']?['name'] ?? '',
      receiverUsername: json['receiver']?['username'] ?? '',
      receiverAvatarUrl: json['receiver']?['avatar_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toString()),
    );
  }
}