import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:fitcoin/core/error/failures.dart';
import 'package:fitcoin/features/login_auth/domain/repositories/login_repository.dart';
import 'package:fitcoin/features/login_auth/domain/models/login_response.dart';
import '../datasources/login_remote_datasource.dart';
import '../models/login_request_model.dart';

class LoginRepositoryImpl implements LoginRepository {
  final LoginRemoteDataSource remoteDataSource;

  LoginRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, LoginResponse>> login({
    required String email,
    required String password,
  }) async {
    try {
      final request = LoginRequest(email: email, password: password);
      final response = await remoteDataSource.login(request);
      return Right(response);
    } on Exception catch (e) {
      if (e is DioException) {
        return Left(ServerFailure(message: e.response?.data['error'] ?? 'Login failed'));
      }
      return Left(ServerFailure(message: e.toString()));
    }
  }
}