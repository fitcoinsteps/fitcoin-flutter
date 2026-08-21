import 'package:fitcoin/features/challenges/domain/entities/user_challenge.dart';

class UserChallengeModel extends UserChallenge {
  const UserChallengeModel({
    required super.id,
    required super.challengeId,
    required super.challengeTitle,
    required super.goalValue,
    required super.timeLimitMinutes,
    required super.startedAt,
    required super.stepsAtStart,
    required super.stepsGained,
    required super.progressPercent,
    required super.timeRemainingMinutes,
  });

  factory UserChallengeModel.fromJson(Map<String, dynamic> json) {
    return UserChallengeModel(
      id: json['id'] ?? 0,
      challengeId: json['challenge']['id'] ?? 0,
      challengeTitle: json['challenge']['title'] ?? '',
      goalValue: json['challenge']['goal_value'] ?? 0,
      timeLimitMinutes: json['challenge']['time_limit_minutes'] ?? 0,
      startedAt: DateTime.parse(json['started_at'] ?? DateTime.now().toString()),
      stepsAtStart: json['steps_at_start'] ?? 0,
      stepsGained: json['steps_gained'] ?? 0,
      progressPercent: (json['progress_percent'] ?? 0).toDouble(),
      timeRemainingMinutes: (json['time_remaining_minutes'] ?? 0).toDouble(),  // ✅ double
    );
  }
}