import 'package:dartz/dartz.dart';
import 'package:fitcoin/core/error/failures.dart';
import 'package:fitcoin/features/logout/domain/repositories/logout_repository.dart';
import '../datasources/logout_remote_datasource.dart';

class LogoutRepositoryImpl implements LogoutRepository {
  final LogoutRemoteDataSource remoteDataSource;

  LogoutRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, String>> logout() async {
    try {
      final message = await remoteDataSource.logout();
      return Right(message);
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> logoutAllDevices() async {
    try {
      final message = await remoteDataSource.logoutAllDevices();
      return Right(message);
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}