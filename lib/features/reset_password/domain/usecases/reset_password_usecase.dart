import 'package:dartz/dartz.dart';
import 'package:fitcoin/core/error/failures.dart';
import '../repositories/reset_password_repository.dart';

class ResetPasswordUseCase {
  final ResetPasswordRepository repository;

  ResetPasswordUseCase(this.repository);

  Future<Either<Failure, String>> call({
    required String email,
    required String token,
    required String password,
    required String passwordConfirmation,
  }) async {
    if (password.isEmpty) {
      return Left(ValidationFailure(message: 'Password is required'));
    }
    if (password.length < 8) {
      return Left(ValidationFailure(message: 'Password must be at least 8 characters'));
    }
    if (password != passwordConfirmation) {
      return Left(ValidationFailure(message: 'Passwords do not match'));
    }

    return await repository.resetPassword(
      email: email,
      token: token,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );
  }
}