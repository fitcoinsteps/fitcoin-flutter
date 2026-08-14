import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:fitcoin/core/error/failures.dart';
import 'package:fitcoin/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:fitcoin/features/auth/domain/repositories/auth_repository.dart';
import 'package:fitcoin/features/auth/domain/entities/user_entity.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late VerifyOtpUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = VerifyOtpUseCase(mockRepository);
  });

  group('VerifyOtpUseCase', () {
    const email = 'john@example.com';
    const otp = '123456';

    test('should return ValidationFailure when email is empty', () async {
      final result = await useCase(email: '', otp: otp);
      expect(
        result,
        Left<Failure, UserEntity>(
          ValidationFailure(message: 'Email is required'),
        ),
      );
    });

    test('should return ValidationFailure when OTP is empty', () async {
      final result = await useCase(email: email, otp: '');
      expect(
        result,
        Left<Failure, UserEntity>(
          ValidationFailure(message: 'OTP is required'),
        ),
      );
    });

    test('should return ValidationFailure when OTP is not 6 digits', () async {
      final result = await useCase(email: email, otp: '12345');
      expect(
        result,
        Left<Failure, UserEntity>(
          ValidationFailure(message: 'OTP must be 6 digits'),
        ),
      );
    });

    test('should return UserEntity when OTP is valid', () async {
      // ✅ Remove 'const' – DateTime is not constant
      final user = UserEntity(
        id: '1',
        employeeCode: 'EMP001',
        username: 'john_doe',
        firstName: 'John',
        lastName: 'Doe',
        displayName: 'John Doe',
        email: 'john@example.com',
        createdAt: DateTime(2024, 1, 1),
      );

      when(() => mockRepository.verifyOtp(email: email, otp: otp))
          .thenAnswer((_) async => Right(user));

      final result = await useCase(email: email, otp: otp);
      expect(result, Right<Failure, UserEntity>(user));
    });
  });
}