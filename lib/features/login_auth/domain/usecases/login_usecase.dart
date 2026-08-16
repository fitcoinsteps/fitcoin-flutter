import 'package:dartz/dartz.dart';
import 'package:fitcoin/core/error/failures.dart';
import '../repositories/login_repository.dart';
import '../models/login_response.dart';

class LoginUseCase {
  final LoginRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, LoginResponse>> call({
    required String email,
    required String password,
  }) async {
    if (email.isEmpty) {
      return Left(ValidationFailure(message: 'Email is required'));
    }
    if (password.isEmpty) {
      return Left(ValidationFailure(message: 'Password is required'));
    }

    return await repository.login(email: email, password: password);
  }
}