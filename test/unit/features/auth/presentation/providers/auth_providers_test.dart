import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:fitcoin/core/error/failures.dart';
import 'package:fitcoin/features/auth/domain/usecases/register_usecase.dart';
import 'package:fitcoin/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:fitcoin/features/auth/presentation/providers/auth_providers.dart';
import 'package:fitcoin/features/auth/presentation/states/auth_states.dart';
import 'package:fitcoin/features/auth/domain/models/registration_response.dart';
import 'package:fitcoin/features/auth/domain/entities/user_entity.dart';

class MockRegisterUseCase extends Mock implements RegisterUseCase {}

class MockVerifyOtpUseCase extends Mock implements VerifyOtpUseCase {}

void main() {
  group('RegistrationNotifier', () {
    late ProviderContainer container;
    late MockRegisterUseCase mockUseCase;

    setUp(() {
      mockUseCase = MockRegisterUseCase();
      container = ProviderContainer(
        overrides: [
          registerUseCaseProvider.overrideWithValue(mockUseCase),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('initial state should be initial', () {
      final state = container.read(registrationProvider);
      expect(state, const RegistrationState.initial());
    });

    test('should emit loading then success on valid registration', () async {
      const response = RegistrationResponse(
        message: 'OTP sent',
        email: 'john@example.com',
        redirect: '/verify-otp',
      );

      when(() => mockUseCase(
        firstName: any(named: 'firstName'),
        lastName: any(named: 'lastName'),
        email: any(named: 'email'),
        password: any(named: 'password'),
        passwordConfirmation: any(named: 'passwordConfirmation'),
        phone: any(named: 'phone'),
      )).thenAnswer((_) async => const Right(response));

      final notifier = container.read(registrationProvider.notifier);
      final future = notifier.register(
        firstName: 'John',
        lastName: 'Doe',
        email: 'john@example.com',
        password: 'password123',
        passwordConfirmation: 'password123',
      );

      expect(container.read(registrationProvider), const RegistrationState.loading());

      await future;

      final state = container.read(registrationProvider);
      state.when(
        initial: () => fail('Should not be initial'),
        loading: () => fail('Should not be loading'),
        success: (resp) => expect(resp, response),
        error: (_) => fail('Should not be error'),
      );
    });

    test('should emit loading then error on failure', () async {
      when(() => mockUseCase(
        firstName: any(named: 'firstName'),
        lastName: any(named: 'lastName'),
        email: any(named: 'email'),
        password: any(named: 'password'),
        passwordConfirmation: any(named: 'passwordConfirmation'),
        phone: any(named: 'phone'),
      )).thenAnswer((_) async => Left(
        ValidationFailure(message: 'Email is required'),
      ));

      final notifier = container.read(registrationProvider.notifier);
      final future = notifier.register(
        firstName: '',
        lastName: 'Doe',
        email: 'john@example.com',
        password: 'password123',
        passwordConfirmation: 'password123',
      );

      expect(container.read(registrationProvider), const RegistrationState.loading());

      await future;

      final state = container.read(registrationProvider);
      state.when(
        initial: () => fail('Should not be initial'),
        loading: () => fail('Should not be loading'),
        success: (_) => fail('Should not be success'),
        error: (message) => expect(message, 'Email is required'),
      );
    });
  });

  group('OtpVerificationNotifier', () {
    late ProviderContainer container;
    late MockVerifyOtpUseCase mockUseCase;

    setUp(() {
      mockUseCase = MockVerifyOtpUseCase();
      container = ProviderContainer(
        overrides: [
          verifyOtpUseCaseProvider.overrideWithValue(mockUseCase),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('initial state should be initial', () {
      final state = container.read(otpVerificationProvider);
      expect(state, const OtpVerificationState.initial());
    });

    test('should emit loading then success on valid OTP', () async {
      // ✅ Remove 'const' – UserEntity with DateTime is not constant
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

      when(() => mockUseCase(
        email: any(named: 'email'),
        otp: any(named: 'otp'),
      )).thenAnswer((_) async => Right(user));

      final notifier = container.read(otpVerificationProvider.notifier);
      final future = notifier.verifyOtp(
        email: 'john@example.com',
        otp: '123456',
      );

      expect(container.read(otpVerificationProvider), const OtpVerificationState.loading());

      await future;

      final state = container.read(otpVerificationProvider);
      state.when(
        initial: () => fail('Should not be initial'),
        loading: () => fail('Should not be loading'),
        success: (user) => expect(user, user),
        error: (_) => fail('Should not be error'),
      );
    });

    test('should emit loading then error on failure', () async {
      when(() => mockUseCase(
        email: any(named: 'email'),
        otp: any(named: 'otp'),
      )).thenAnswer((_) async => Left(
        ValidationFailure(message: 'Invalid OTP'),
      ));

      final notifier = container.read(otpVerificationProvider.notifier);
      final future = notifier.verifyOtp(
        email: 'john@example.com',
        otp: '000000',
      );

      expect(container.read(otpVerificationProvider), const OtpVerificationState.loading());

      await future;

      final state = container.read(otpVerificationProvider);
      state.when(
        initial: () => fail('Should not be initial'),
        loading: () => fail('Should not be loading'),
        success: (_) => fail('Should not be success'),
        error: (message) => expect(message, 'Invalid OTP'),
      );
    });
  });
}