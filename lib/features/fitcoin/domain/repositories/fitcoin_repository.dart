import 'package:dartz/dartz.dart';
import 'package:fitcoin/core/error/failures.dart';
import 'package:fitcoin/features/fitcoin/domain/entities/fitcoin_balance.dart';
import 'package:fitcoin/features/fitcoin/domain/entities/fitcoin_convert_result.dart';

abstract class FitcoinRepository {
  Future<Either<Failure, FitcoinBalance>> getBalance();
  Future<Either<Failure, FitcoinConvertResult>> convertSteps(int stepsToConvert);
}