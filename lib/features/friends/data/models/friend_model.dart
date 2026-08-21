import 'package:fitcoin/features/friends/domain/entities/friend.dart';

class FriendModel extends Friend {
  const FriendModel({
    required super.id,
    required super.name,
    required super.username,
    required super.avatarUrl,
    required super.todaySteps,
    required super.goal,
    required super.progressPercent,
    required super.isCompleted,
    required super.isOnline,
  });

  factory FriendModel.fromJson(Map<String, dynamic> json) {
    return FriendModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      username: json['username'] ?? '',
      avatarUrl: json['avatar_url'] as String?,
      todaySteps: json['today_steps'] ?? 0,
      goal: json['goal'] ?? 10000,
      progressPercent: (json['progress_percent'] ?? 0).toDouble(),
      isCompleted: json['is_completed'] ?? false,
      isOnline: json['is_online'] ?? false,
    );
  }
}