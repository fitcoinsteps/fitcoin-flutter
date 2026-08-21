import 'package:dartz/dartz.dart';
import 'package:fitcoin/core/error/failures.dart';
import 'package:fitcoin/features/step_counter/domain/entities/step_data.dart';

abstract class StepRepository {
  Future<Either<Failure, StepData>> getTodaySteps();
  Future<Either<Failure, void>> saveDailySteps(StepData stepData);
  Future<Either<Failure, StepData>> syncSteps(StepData stepData);
  Future<Either<Failure, void>> updateGoal(int goal); // ✅ add this line
  Stream<int> startStepStream();
}