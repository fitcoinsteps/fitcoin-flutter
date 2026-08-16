import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitcoin/core/cache/cache_service.dart';
import 'package:fitcoin/features/logout/data/datasources/logout_remote_datasource.dart';
import 'package:fitcoin/features/logout/data/repositories/logout_repository_impl.dart';
import 'package:fitcoin/features/logout/domain/repositories/logout_repository.dart';
import 'package:fitcoin/features/logout/domain/usecases/logout_usecase.dart';
import '../states/logout_states.dart';

final logoutRemoteDataSourceProvider = Provider<LogoutRemoteDataSource>((ref) {
  final cacheService = ref.watch(cacheServiceProvider);
  return LogoutRemoteDataSource(cacheService: cacheService);
});

final logoutRepositoryProvider = Provider<LogoutRepository>((ref) {
  final remoteDataSource = ref.read(logoutRemoteDataSourceProvider);
  return LogoutRepositoryImpl(remoteDataSource);
});

final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  final repository = ref.read(logoutRepositoryProvider);
  return LogoutUseCase(repository);
});

final logoutAllDevicesUseCaseProvider = Provider<LogoutAllDevicesUseCase>((ref) {
  final repository = ref.read(logoutRepositoryProvider);
  return LogoutAllDevicesUseCase(repository);
});

class LogoutNotifier extends StateNotifier<LogoutState> {
  final LogoutUseCase logoutUseCase;
  final LogoutAllDevicesUseCase logoutAllDevicesUseCase;

  LogoutNotifier(
      this.logoutUseCase,
      this.logoutAllDevicesUseCase,
      ) : super(const LogoutInitial());

  Future<void> logout() async {
    state = const LogoutLoading();

    final result = await logoutUseCase();

    result.fold(
          (failure) => state = LogoutError(failure.message),
          (message) => state = LogoutSuccess(message),
    );
  }

  Future<void> logoutAllDevices() async {
    state = const LogoutLoading();

    final result = await logoutAllDevicesUseCase();

    result.fold(
          (failure) => state = LogoutError(failure.message),
          (message) => state = LogoutSuccess(message),
    );
  }

  void reset() {
    state = const LogoutInitial();
  }
}

final logoutProvider = StateNotifierProvider<LogoutNotifier, LogoutState>(
      (ref) => LogoutNotifier(
    ref.read(logoutUseCaseProvider),
    ref.read(logoutAllDevicesUseCaseProvider),
  ),
);