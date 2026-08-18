import 'package:dartz/dartz.dart';
import 'package:fitcoin/core/error/failures.dart';
import 'package:fitcoin/features/fitcoin/data/datasources/fitcoin_remote_source.dart';
import 'package:fitcoin/features/fitcoin/domain/entities/fitcoin_balance.dart';
import 'package:fitcoin/features/fitcoin/domain/entities/fitcoin_convert_result.dart';
import 'package:fitcoin/features/fitcoin/domain/repositories/fitcoin_repository.dart';

class FitcoinRepositoryImpl implements FitcoinRepository {
  final FitcoinRemoteSource remoteSource;

  FitcoinRepositoryImpl({required this.remoteSource});

  @override
  Future<Either<Failure, FitcoinBalance>> getBalance() async {
    try {
      final balance = await remoteSource.getBalance();
      return Right(balance);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, FitcoinConvertResult>> convertSteps(int stepsToConvert) async {
    try {
      final result = await remoteSource.convertSteps(stepsToConvert);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}