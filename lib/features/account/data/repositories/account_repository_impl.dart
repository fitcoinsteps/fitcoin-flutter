import 'package:dartz/dartz.dart';
import 'package:fitcoin/core/error/failures.dart';
import 'package:fitcoin/features/account/domain/repositories/account_repository.dart';
import '../datasources/account_remote_source.dart';

class AccountRepositoryImpl implements AccountRepository {
  final AccountRemoteSource remoteSource;

  AccountRepositoryImpl({required this.remoteSource});

  @override
  Future<Either<Failure, void>> deactivateAccount({required String password}) async {
    try {
      await remoteSource.deactivateAccount(password: password);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}