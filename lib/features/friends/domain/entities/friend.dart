class Friend {
  final int id;
  final String name;
  final String username;
  final String? avatarUrl;
  final int todaySteps;
  final int goal;
  final double progressPercent;
  final bool isCompleted;
  final bool isOnline;

  const Friend({
    required this.id,
    required this.name,
    required this.username,
    required this.avatarUrl,
    required this.todaySteps,
    required this.goal,
    required this.progressPercent,
    required this.isCompleted,
    required this.isOnline,
  });
}