import 'package:dartz/dartz.dart';
import 'package:fitcoin/core/error/failures.dart';
import 'package:fitcoin/features/forgot_password/domain/repositories/forgot_password_repository.dart';
import '../datasources/forgot_password_remote_datasource.dart';

class ForgotPasswordRepositoryImpl implements ForgotPasswordRepository {
  final ForgotPasswordRemoteDataSource remoteDataSource;

  ForgotPasswordRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, String>> sendResetOtp(String email) async {
    try {
      final message = await remoteDataSource.sendResetOtp(email);
      return Right(message);
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString().replaceAll('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, String>> verifyResetOtp({
    required String email,
    required String code,
  }) async {
    try {
      final token = await remoteDataSource.verifyResetOtp(
        email: email,
        code: code,
      );
      return Right(token);
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString().replaceAll('Exception: ', '')));
    }
  }
}