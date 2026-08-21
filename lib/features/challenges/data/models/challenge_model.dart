import 'package:fitcoin/features/challenges/domain/entities/challenge.dart';

class ChallengeModel extends Challenge {
  const ChallengeModel({
    required super.id,
    required super.uuid,
    required super.title,
    required super.description,
    required super.goalType,
    required super.goalValue,
    required super.timeLimitMinutes,
    required super.rewardFitcoins,
  });

  factory ChallengeModel.fromJson(Map<String, dynamic> json) {
    return ChallengeModel(
      id: json['id'] ?? 0,
      uuid: json['uuid'] ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      goalType: json['goal_type'] ?? 'steps',
      goalValue: json['goal_value'] ?? 0,
      timeLimitMinutes: json['time_limit_minutes'] ?? 0,
      rewardFitcoins: json['reward_fitcoins'] ?? 0,
    );
  }
}