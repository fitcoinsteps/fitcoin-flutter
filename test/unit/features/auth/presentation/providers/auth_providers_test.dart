import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitcoin/core/error/failures.dart';
import 'package:fitcoin/features/auth/presentation/providers/auth_providers.dart';
import 'package:fitcoin/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:fitcoin/features/auth/domain/repositories/auth_repository.dart';
import 'package:fitcoin/features/auth/domain/entities/user_entity.dart';
import 'package:fitcoin/features/auth/presentation/states/auth_states.dart';

class MockVerifyOtpUseCase extends Mock implements VerifyOtpUseCase {}

void main() {
  late OtpVerificationNotifier notifier;
  late MockVerifyOtpUseCase mockVerifyOtpUseCase;

  setUp(() {
    mockVerifyOtpUseCase = MockVerifyOtpUseCase();
    notifier = OtpVerificationNotifier(mockVerifyOtpUseCase);
  });

  group('OtpVerificationNotifier', () {
    const email = 'john@example.com';
    const code = '123456'; // ✅ Changed from 'otp' to 'code'

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

    test('should emit success state when OTP is valid', () async {
      when(() => mockVerifyOtpUseCase(email: email, code: code)) // ✅ Changed
          .thenAnswer((_) async => Right(user));

      await notifier.verifyOtp(email: email, code: code); // ✅ Changed

      expect(
        notifier.state,
        OtpVerificationState.success(user: user),
      );
    });

    test('should emit error state when OTP verification fails', () async {
      when(() => mockVerifyOtpUseCase(email: email, code: code)) // ✅ Changed
          .thenAnswer(
            (_) async => Left(
          ServerFailure(message: 'Invalid OTP'),
        ),
      );

      await notifier.verifyOtp(email: email, code: code); // ✅ Changed

      expect(
        notifier.state,
        OtpVerificationState.error(message: 'Invalid OTP'),
      );
    });
  });
}