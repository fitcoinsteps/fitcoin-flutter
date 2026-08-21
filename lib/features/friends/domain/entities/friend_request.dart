class FriendRequest {
  final int friendshipId;
  final int senderId;   // for incoming
  final String senderName;
  final String senderUsername;
  final String? senderAvatarUrl;
  final int receiverId; // for outgoing
  final String receiverName;
  final String receiverUsername;
  final String? receiverAvatarUrl;
  final DateTime createdAt;

  const FriendRequest({
    required this.friendshipId,
    required this.senderId,
    required this.senderName,
    required this.senderUsername,
    required this.senderAvatarUrl,
    required this.receiverId,
    required this.receiverName,
    required this.receiverUsername,
    required this.receiverAvatarUrl,
    required this.createdAt,
  });
}