import 'package:dartz/dartz.dart';
import 'package:fitcoin/core/error/failures.dart';
import 'package:fitcoin/features/step_counter/domain/entities/step_data.dart';
import 'package:fitcoin/features/step_counter/domain/repositories/step_repository.dart';

class SaveDailySteps {
  final StepRepository repository;
  SaveDailySteps(this.repository);

  Future<Either<Failure, void>> call(StepData stepData) =>
      repository.saveDailySteps(stepData);
}