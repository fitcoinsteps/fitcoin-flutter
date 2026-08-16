import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitcoin/features/reset_password/data/datasources/reset_password_remote_datasource.dart';
import 'package:fitcoin/features/reset_password/data/repositories/reset_password_repository_impl.dart';
import 'package:fitcoin/features/reset_password/domain/repositories/reset_password_repository.dart';
import 'package:fitcoin/features/reset_password/domain/usecases/reset_password_usecase.dart';
import '../states/reset_password_states.dart';

final resetPasswordRemoteDataSourceProvider = Provider<ResetPasswordRemoteDataSource>((ref) {
  return ResetPasswordRemoteDataSource();
});

final resetPasswordRepositoryProvider = Provider<ResetPasswordRepository>((ref) {
  final remoteDataSource = ref.read(resetPasswordRemoteDataSourceProvider);
  return ResetPasswordRepositoryImpl(remoteDataSource);
});

final resetPasswordUseCaseProvider = Provider<ResetPasswordUseCase>((ref) {
  final repository = ref.read(resetPasswordRepositoryProvider);
  return ResetPasswordUseCase(repository);
});

class ResetPasswordNotifier extends StateNotifier<ResetPasswordState> {
  final ResetPasswordUseCase resetPasswordUseCase;

  ResetPasswordNotifier(this.resetPasswordUseCase)
      : super(const ResetPasswordInitial());

  Future<void> resetPassword({
    required String email,
    required String token,
    required String password,
    required String passwordConfirmation,
  }) async {
    state = const ResetPasswordLoading();

    final result = await resetPasswordUseCase(
      email: email,
      token: token,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );

    result.fold(
          (failure) => state = ResetPasswordError(failure.message),
          (message) => state = ResetPasswordSuccess(message),
    );
  }

  void reset() {
    state = const ResetPasswordInitial();
  }
}

final resetPasswordProvider =
StateNotifierProvider<ResetPasswordNotifier, ResetPasswordState>(
      (ref) => ResetPasswordNotifier(ref.read(resetPasswordUseCaseProvider)),
);