import 'package:dartz/dartz.dart';
import 'package:fitcoin/core/error/failures.dart';
import '../repositories/forgot_password_repository.dart';

class ForgotPasswordUseCase {
  final ForgotPasswordRepository repository;

  ForgotPasswordUseCase(this.repository);

  Future<Either<Failure, String>> call(String email) async {
    if (email.isEmpty) {
      return Left(ValidationFailure(message: 'Email is required'));
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      return Left(ValidationFailure(message: 'Enter valid email'));
    }

    return await repository.sendResetOtp(email);
  }
}