import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/verify_otp_usecase.dart';
import 'package:fitcoin/core/cache/cache_service.dart';
import '../states/auth_states.dart';

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final cacheService = ref.watch(cacheServiceProvider);
  return AuthRemoteDataSource(cacheService: cacheService);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remoteDataSource = ref.read(authRemoteDataSourceProvider);
  return AuthRepositoryImpl(remoteDataSource);
});

final registerUseCaseProvider = Provider<RegisterUseCase>((ref) {
  final repository = ref.read(authRepositoryProvider);
  return RegisterUseCase(repository);
});

final verifyOtpUseCaseProvider = Provider<VerifyOtpUseCase>((ref) {
  final repository = ref.read(authRepositoryProvider);
  return VerifyOtpUseCase(repository);
});

class RegistrationNotifier extends StateNotifier<RegistrationState> {
  final RegisterUseCase registerUseCase;

  RegistrationNotifier(this.registerUseCase)
      : super(RegistrationState.initial());

  Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? phone,
  }) async {
    state = RegistrationState.loading();

    final result = await registerUseCase(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
      passwordConfirmation: passwordConfirmation,
      phone: phone,
    );

    result.fold(
          (failure) => state = RegistrationState.error(message: failure.message),
          (response) => state = RegistrationState.success(response: response),
    );
  }

  void reset() {
    state = RegistrationState.initial();
  }
}

final registrationProvider =
StateNotifierProvider<RegistrationNotifier, RegistrationState>(
        (ref) => RegistrationNotifier(ref.read(registerUseCaseProvider)));

class OtpVerificationNotifier extends StateNotifier<OtpVerificationState> {
  final VerifyOtpUseCase verifyOtpUseCase;

  OtpVerificationNotifier(this.verifyOtpUseCase)
      : super(OtpVerificationState.initial());

  Future<void> verifyOtp({
    required String email,
    required String code,
  }) async {
    state = OtpVerificationState.loading();

    final result = await verifyOtpUseCase(email: email, code: code);

    result.fold(
          (failure) => state = OtpVerificationState.error(message: failure.message),
          (otpResult) => state = OtpVerificationState.success(result: otpResult),
    );
  }

  void reset() {
    state = OtpVerificationState.initial();
  }
}

final otpVerificationProvider =
StateNotifierProvider<OtpVerificationNotifier, OtpVerificationState>(
        (ref) => OtpVerificationNotifier(ref.read(verifyOtpUseCaseProvider)));