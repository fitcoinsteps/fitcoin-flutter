import 'dart:async';
import 'package:fitcoin/features/step_counter/domain/repositories/step_repository.dart';

class ValidateStepsUseCase {
  final StepRepository repository;
  ValidateStepsUseCase(this.repository);

  Stream<int> call() => repository.startStepStream();
}