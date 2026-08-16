import 'package:dartz/dartz.dart';
import 'package:fitcoin/core/error/failures.dart';
import '../repositories/logout_repository.dart';

class LogoutUseCase {
  final LogoutRepository repository;

  LogoutUseCase(this.repository);

  Future<Either<Failure, String>> call() async {
    return await repository.logout();
  }
}

class LogoutAllDevicesUseCase {
  final LogoutRepository repository;

  LogoutAllDevicesUseCase(this.repository);

  Future<Either<Failure, String>> call() async {
    return await repository.logoutAllDevices();
  }
}