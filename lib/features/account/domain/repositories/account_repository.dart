import 'package:dartz/dartz.dart';
import 'package:fitcoin/core/error/failures.dart';

abstract class AccountRepository {
  Future<Either<Failure, void>> deactivateAccount({required String password});
}