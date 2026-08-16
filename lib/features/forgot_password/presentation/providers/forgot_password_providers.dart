import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitcoin/features/forgot_password/data/datasources/forgot_password_remote_datasource.dart';
import 'package:fitcoin/features/forgot_password/data/repositories/forgot_password_repository_impl.dart';
import 'package:fitcoin/features/forgot_password/domain/repositories/forgot_password_repository.dart';
import 'package:fitcoin/features/forgot_password/domain/usecases/forgot_password_usecase.dart';
import '../states/forgot_password_states.dart';

final forgotPasswordRemoteDataSourceProvider = Provider<ForgotPasswordRemoteDataSource>((ref) {
  return ForgotPasswordRemoteDataSource();
});

final forgotPasswordRepositoryProvider = Provider<ForgotPasswordRepository>((ref) {
  final remoteDataSource = ref.read(forgotPasswordRemoteDataSourceProvider);
  return ForgotPasswordRepositoryImpl(remoteDataSource);
});

final forgotPasswordUseCaseProvider = Provider<ForgotPasswordUseCase>((ref) {
  final repository = ref.read(forgotPasswordRepositoryProvider);
  return ForgotPasswordUseCase(repository);
});

class ForgotPasswordNotifier extends StateNotifier<ForgotPasswordState> {
  final ForgotPasswordUseCase forgotPasswordUseCase;

  ForgotPasswordNotifier(this.forgotPasswordUseCase)
      : super(const ForgotPasswordInitial());

  Future<void> sendResetOtp(String email) async {
    state = const ForgotPasswordLoading();

    final result = await forgotPasswordUseCase(email);

    result.fold(
          (failure) => state = ForgotPasswordError(failure.message),
          (message) => state = ForgotPasswordSuccess(message, email),
    );
  }

  void reset() {
    state = const ForgotPasswordInitial();
  }
}

final forgotPasswordProvider =
StateNotifierProvider<ForgotPasswordNotifier, ForgotPasswordState>(
      (ref) => ForgotPasswordNotifier(ref.read(forgotPasswordUseCaseProvider)),
);