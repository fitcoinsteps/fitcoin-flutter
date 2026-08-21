import 'package:fitcoin/features/profile/domain/entities/user_profile.dart';

class UserProfileModel extends UserProfile {
  UserProfileModel({
    required super.id,
    required super.uuid,
    required super.username,
    required super.firstName,
    required super.lastName,
    required super.displayName,
    required super.email,
    required super.phone,
    required super.role,
    required super.avatarUrl,
    required super.fitcoinBalance,
    required super.todaySteps,
    required super.dailyGoal,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'].toString(),
      uuid: json['uuid'] ?? '',
      username: json['username'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      displayName: json['display_name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      role: json['role'] ?? 'user',
      avatarUrl: json['avatar'] as String?,
      fitcoinBalance: int.parse(json['fitcoin_balance'].toString()),
      todaySteps: int.parse(json['today_steps'].toString()),
      dailyGoal: int.parse(json['daily_goal'].toString()),
    );
  }
}