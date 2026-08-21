import 'package:dartz/dartz.dart';
import 'package:fitcoin/core/error/failures.dart';
import '../repositories/account_repository.dart';

class DeactivateAccount {
  final AccountRepository repository;
  DeactivateAccount(this.repository);

  Future<Either<Failure, void>> call({required String password}) =>
      repository.deactivateAccount(password: password);
}