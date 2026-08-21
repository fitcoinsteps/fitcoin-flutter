class UserChallenge {
  final int id;
  final int challengeId;
  final String challengeTitle;
  final int goalValue;
  final int timeLimitMinutes;
  final DateTime startedAt;
  final int stepsAtStart;
  final int stepsGained;
  final double progressPercent;
  final double timeRemainingMinutes;   // ✅ changed to double

  const UserChallenge({
    required this.id,
    required this.challengeId,
    required this.challengeTitle,
    required this.goalValue,
    required this.timeLimitMinutes,
    required this.startedAt,
    required this.stepsAtStart,
    required this.stepsGained,
    required this.progressPercent,
    required this.timeRemainingMinutes,
  });
}