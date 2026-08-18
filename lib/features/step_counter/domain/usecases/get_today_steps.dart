import 'package:dartz/dartz.dart';
import 'package:fitcoin/core/error/failures.dart';
import 'package:fitcoin/features/step_counter/domain/entities/step_data.dart';
import 'package:fitcoin/features/step_counter/domain/repositories/step_repository.dart';

class GetTodaySteps {
  final StepRepository repository;
  GetTodaySteps(this.repository);

  Future<Either<Failure, StepData>> call() => repository.getTodaySteps();
}