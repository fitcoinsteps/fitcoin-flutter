import 'package:dartz/dartz.dart';
import 'package:fitcoin/core/error/failures.dart';

abstract class ForgotPasswordRepository {
  Future<Either<Failure, String>> sendResetOtp(String email);
  Future<Either<Failure, String>> verifyResetOtp({
    required String email,
    required String code,
  });
}