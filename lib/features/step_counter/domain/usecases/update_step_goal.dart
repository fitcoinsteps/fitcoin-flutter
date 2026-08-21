import 'package:dartz/dartz.dart';
import 'package:fitcoin/core/error/failures.dart';
import 'package:fitcoin/features/step_counter/domain/repositories/step_repository.dart';

class UpdateStepGoal {
  final StepRepository repository;
  const UpdateStepGoal(this.repository);

  Future<Either<Failure, void>> call(int goal) => repository.updateGoal(goal);
}