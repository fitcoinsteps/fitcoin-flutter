import 'package:dartz/dartz.dart';
import 'package:fitcoin/core/error/failures.dart';

abstract class ResetPasswordRepository {
  Future<Either<Failure, String>> resetPassword({
    required String email,
    required String token,
    required String password,
    required String passwordConfirmation,
  });
}