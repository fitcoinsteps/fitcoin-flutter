import 'dart:async';
import 'package:fitcoin/features/step_counter/domain/entities/step_data.dart';
import 'package:fitcoin/features/step_counter/domain/repositories/step_repository.dart';

class DetectFraudUseCase {
  final StepRepository repository;
  DetectFraudUseCase(this.repository);

  Future<bool> isSuspicious(StepData stepData) async {
    // Basic rule: more than 200 steps per minute is suspicious
    final stepsPerMinute = stepData.steps / DateTime.now().difference(DateTime.now().subtract(Duration(minutes: 1))).inMinutes;
    return stepsPerMinute > 200;
  }
}