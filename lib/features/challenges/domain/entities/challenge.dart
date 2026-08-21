class Challenge {
  final int id;
  final String uuid;
  final String title;
  final String? description;
  final String goalType;
  final int goalValue;
  final int timeLimitMinutes;
  final int rewardFitcoins;

  const Challenge({
    required this.id,
    required this.uuid,
    required this.title,
    required this.description,
    required this.goalType,
    required this.goalValue,
    required this.timeLimitMinutes,
    required this.rewardFitcoins,
  });
}