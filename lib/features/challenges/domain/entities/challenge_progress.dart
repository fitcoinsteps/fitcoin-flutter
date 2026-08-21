class ChallengeProgress {
  final String status;
  final double progressPercent;
  final int stepsGained;
  final double timeRemainingMinutes;   // ✅ double
  final int stepsNeeded;
  final int rewardEarned;

  const ChallengeProgress({
    required this.status,
    required this.progressPercent,
    required this.stepsGained,
    required this.timeRemainingMinutes,
    required this.stepsNeeded,
    required this.rewardEarned,
  });
}