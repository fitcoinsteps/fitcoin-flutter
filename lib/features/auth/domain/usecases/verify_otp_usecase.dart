import 'package:dartz/dartz.dart';
import 'package:fitcoin/core/error/failures.dart';
import '../repositories/auth_repository.dart';
import '../entities/user_entity.dart';

class VerifyOtpUseCase {
  final AuthRepository repository;

  VerifyOtpUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call({
    required String email,
    required String otp,
  }) async {
    if (email.isEmpty) {
      return Left(ValidationFailure(message: 'Email is required'));
    }
    if (otp.isEmpty) {
      return Left(ValidationFailure(message: 'OTP is required'));
    }
    if (otp.length != 6) {
      return Left(ValidationFailure(message: 'OTP must be 6 digits'));
    }

    return await repository.verifyOtp(email: email, otp: otp);
  }
}
