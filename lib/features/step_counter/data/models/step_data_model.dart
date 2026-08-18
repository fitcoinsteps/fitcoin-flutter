import 'package:fitcoin/features/step_counter/domain/entities/step_data.dart';

class StepDataModel extends StepData {
  StepDataModel({
    required super.steps,
    required super.goal,
    required super.date,
  });

  factory StepDataModel.fromJson(Map<String, dynamic> json) {
    return StepDataModel(
      steps: json['steps'] ?? 0,
      goal: json['goal'] ?? 10000,
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'steps': steps,
      'goal': goal,
      'date': _formatDate(date),
    };
  }

  String _formatDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }
}