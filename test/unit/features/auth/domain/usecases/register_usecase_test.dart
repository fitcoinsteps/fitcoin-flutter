import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:fitcoin/core/error/failures.dart';
import 'package:fitcoin/features/auth/domain/usecases/register_usecase.dart';
import 'package:fitcoin/features/auth/domain/repositories/auth_repository.dart';
import 'package:fitcoin/features/auth/domain/models/registration_response.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late RegisterUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = RegisterUseCase(mockRepository);
  });

  group('RegisterUseCase', () {
    const validParams = (
    firstName: 'John',
    lastName: 'Doe',
    email: 'john@example.com',
    password: 'password123',
    passwordConfirmation: 'password123',
    phone: null,
    );

    test('should return ValidationFailure when firstName is empty', () async {
      final result = await useCase(
        firstName: '',
        lastName: validParams.lastName,
        email: validParams.email,
        password: validParams.password,
        passwordConfirmation: validParams.passwordConfirmation,
      );

      expect(
        result,
        Left<Failure, RegistrationResponse>(
          ValidationFailure(message: 'First name is required'),
        ),
      );
    });

    test('should return ValidationFailure when lastName is empty', () async {
      final result = await useCase(
        firstName: validParams.firstName,
        lastName: '',
        email: validParams.email,
        password: validParams.password,
        passwordConfirmation: validParams.passwordConfirmation,
      );

      expect(
        result,
        Left<Failure, RegistrationResponse>(
          ValidationFailure(message: 'Last name is required'),
        ),
      );
    });

    test('should return ValidationFailure when email is empty', () async {
      final result = await useCase(
        firstName: validParams.firstName,
        lastName: validParams.lastName,
        email: '',
        password: validParams.password,
        passwordConfirmation: validParams.passwordConfirmation,
      );

      expect(
        result,
        Left<Failure, RegistrationResponse>(
          ValidationFailure(message: 'Email is required'),
        ),
      );
    });

    test('should return ValidationFailure when email is invalid', () async {
      final result = await useCase(
        firstName: validParams.firstName,
        lastName: validParams.lastName,
        email: 'invalid-email',
        password: validParams.password,
        passwordConfirmation: validParams.passwordConfirmation,
      );

      expect(
        result,
        Left<Failure, RegistrationResponse>(
          ValidationFailure(message: 'Please enter a valid email'),
        ),
      );
    });

    test('should return ValidationFailure when password is empty', () async {
      final result = await useCase(
        firstName: validParams.firstName,
        lastName: validParams.lastName,
        email: validParams.email,
        password: '',
        passwordConfirmation: '',
      );

      expect(
        result,
        Left<Failure, RegistrationResponse>(
          ValidationFailure(message: 'Password is required'),
        ),
      );
    });

    test('should return ValidationFailure when password is too short', () async {
      final result = await useCase(
        firstName: validParams.firstName,
        lastName: validParams.lastName,
        email: validParams.email,
        password: '12345',
        passwordConfirmation: '12345',
      );

      expect(
        result,
        Left<Failure, RegistrationResponse>(
          ValidationFailure(message: 'Password must be at least 6 characters'),
        ),
      );
    });

    test('should return ValidationFailure when passwords do not match', () async {
      final result = await useCase(
        firstName: validParams.firstName,
        lastName: validParams.lastName,
        email: validParams.email,
        password: 'password123',
        passwordConfirmation: 'password456',
      );

      expect(
        result,
        Left<Failure, RegistrationResponse>(
          ValidationFailure(message: 'Passwords do not match'),
        ),
      );
    });

    test('should return RegistrationResponse when validations pass', () async {
      const response = RegistrationResponse(
        success: true,              // <-- add this
        message: 'OTP sent',
        email: 'john@example.com',
        redirect: '/verify-otp',
      );

      when(() => mockRepository.register(
        firstName: any(named: 'firstName'),
        lastName: any(named: 'lastName'),
        email: any(named: 'email'),
        password: any(named: 'password'),
        passwordConfirmation: any(named: 'passwordConfirmation'),
        phone: any(named: 'phone'),
      )).thenAnswer((_) async => const Right(response));

      final result = await useCase(
        firstName: validParams.firstName,
        lastName: validParams.lastName,
        email: validParams.email,
        password: validParams.password,
        passwordConfirmation: validParams.passwordConfirmation,
      );

      expect(result, const Right<Failure, RegistrationResponse>(response));
    });
  });
}