import 'package:dartz/dartz.dart';
import 'package:fitcoin/core/error/failures.dart';
import 'package:fitcoin/features/fitcoin/domain/entities/fitcoin_balance.dart';
import 'package:fitcoin/features/fitcoin/domain/repositories/fitcoin_repository.dart';

class GetFitcoinBalance {
  final FitcoinRepository repository;

  const GetFitcoinBalance(this.repository);

  Future<Either<Failure, FitcoinBalance>> call() => repository.getBalance();
}