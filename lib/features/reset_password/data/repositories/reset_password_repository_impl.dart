import 'package:dartz/dartz.dart';
import 'package:fitcoin/core/error/failures.dart';
import 'package:fitcoin/features/reset_password/domain/repositories/reset_password_repository.dart';
import '../datasources/reset_password_remote_datasource.dart';

class ResetPasswordRepositoryImpl implements ResetPasswordRepository {
  final ResetPasswordRemoteDataSource remoteDataSource;

  ResetPasswordRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, String>> resetPassword({
    required String email,
    required String token,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final message = await remoteDataSource.resetPassword(
        email: email,
        token: token,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );
      return Right(message);
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString().replaceAll('Exception: ', '')));
    }
  }
}