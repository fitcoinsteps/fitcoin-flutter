class StepData {
  final int steps;
  final int goal;
  final DateTime date;

  StepData({
    required this.steps,
    required this.goal,
    required this.date,
  });

  double get progress => goal == 0 ? 0 : steps / goal;
}