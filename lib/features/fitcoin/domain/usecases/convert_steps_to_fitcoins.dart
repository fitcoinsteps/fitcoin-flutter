import 'package:dartz/dartz.dart';
import 'package:fitcoin/core/error/failures.dart';
import 'package:fitcoin/features/fitcoin/domain/entities/fitcoin_convert_result.dart';
import 'package:fitcoin/features/fitcoin/domain/repositories/fitcoin_repository.dart';

class ConvertStepsToFitcoins {
  final FitcoinRepository repository;

  const ConvertStepsToFitcoins(this.repository);

  Future<Either<Failure, FitcoinConvertResult>> call(int stepsToConvert) =>
      repository.convertSteps(stepsToConvert);
}