import 'package:dartz/dartz.dart';
import 'package:fitcoin/core/error/failures.dart';
import '../../presentation/states/auth_states.dart'; // ✅ for OtpVerificationResult
import '../repositories/auth_repository.dart';

class VerifyOtpUseCase {
  final AuthRepository repository;

  VerifyOtpUseCase(this.repository);

  Future<Either<Failure, OtpVerificationResult>> call({
    required String email,
    required String code,
  }) async {
    if (email.isEmpty) {
      return Left(ValidationFailure(message: 'Email is required'));
    }
    if (code.isEmpty) {
      return Left(ValidationFailure(message: 'OTP is required'));
    }
    if (code.length != 6) {
      return Left(ValidationFailure(message: 'OTP must be 6 digits'));
    }

    return await repository.verifyOtp(email: email, code: code);
  }
}