import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitcoin/core/cache/cache_service.dart';
import 'package:fitcoin/features/login_auth/data/datasources/login_remote_datasource.dart';
import 'package:fitcoin/features/login_auth/data/repositories/login_repository_impl.dart';
import 'package:fitcoin/features/login_auth/domain/repositories/login_repository.dart';
import 'package:fitcoin/features/login_auth/domain/usecases/login_usecase.dart';
import '../states/login_states.dart';

final loginRemoteDataSourceProvider = Provider<LoginRemoteDataSource>((ref) {
  final cacheService = ref.watch(cacheServiceProvider);
  return LoginRemoteDataSource(cacheService: cacheService);
});

final loginRepositoryProvider = Provider<LoginRepository>((ref) {
  final remoteDataSource = ref.read(loginRemoteDataSourceProvider);
  return LoginRepositoryImpl(remoteDataSource);
});

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  final repository = ref.read(loginRepositoryProvider);
  return LoginUseCase(repository);
});

class LoginNotifier extends StateNotifier<LoginState> {
  final LoginUseCase loginUseCase;

  LoginNotifier(this.loginUseCase) : super(const LoginInitial());

  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = const LoginLoading();

    final result = await loginUseCase(email: email, password: password);

    result.fold(
          (failure) => state = LoginError(failure.message),
          (response) => state = LoginSuccess(response),
    );
  }

  void reset() {
    state = const LoginInitial();
  }
}

final loginProvider = StateNotifierProvider<LoginNotifier, LoginState>(
      (ref) => LoginNotifier(ref.read(loginUseCaseProvider)),
);