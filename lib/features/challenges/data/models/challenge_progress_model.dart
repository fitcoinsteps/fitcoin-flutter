import 'package:fitcoin/features/challenges/domain/entities/challenge_progress.dart';

class ChallengeProgressModel extends ChallengeProgress {
  const ChallengeProgressModel({
    required super.status,
    required super.progressPercent,
    required super.stepsGained,
    required super.timeRemainingMinutes,
    required super.stepsNeeded,
    required super.rewardEarned,
  });

  factory ChallengeProgressModel.fromJson(Map<String, dynamic> json) {
    return ChallengeProgressModel(
      status: json['status'] ?? 'active',
      progressPercent: (json['progress_percent'] ?? 0).toDouble(),
      stepsGained: json['steps_gained'] ?? 0,
      timeRemainingMinutes: (json['time_remaining_minutes'] ?? 0).toDouble(),  // ✅ double
      stepsNeeded: json['steps_needed'] ?? 0,
      rewardEarned: json['reward_earned'] ?? 0,
    );
  }
}