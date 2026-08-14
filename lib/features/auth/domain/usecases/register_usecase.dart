import 'package:dartz/dartz.dart';
import 'package:fitcoin/core/error/failures.dart';
import '../repositories/auth_repository.dart';
import '../models/registration_response.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<Either<Failure, RegistrationResponse>> call({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? phone,
  }) async {
    if (firstName.isEmpty) {
      return Left(ValidationFailure(message: 'First name is required'));
    }
    if (lastName.isEmpty) {
      return Left(ValidationFailure(message: 'Last name is required'));
    }
    if (email.isEmpty) {
      return Left(ValidationFailure(message: 'Email is required'));
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      return Left(ValidationFailure(message: 'Please enter a valid email'));
    }
    if (password.isEmpty) {
      return Left(ValidationFailure(message: 'Password is required'));
    }
    if (password.length < 6) {
      return Left(
        ValidationFailure(message: 'Password must be at least 6 characters'),
      );
    }
    if (password != passwordConfirmation) {
      return Left(ValidationFailure(message: 'Passwords do not match'));
    }

    return await repository.register(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
      passwordConfirmation: passwordConfirmation,
      phone: phone,
    );
  }
}
