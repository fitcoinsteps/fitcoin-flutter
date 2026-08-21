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
    } on DioException catch (e) {
      // Extract message from Dio response
      final data = e.response?.data;
      String message = 'Login failed';
      if (data is Map && data.containsKey('error')) {
        message = data['error'] as String;
      } else if (data is Map && data.containsKey('message')) {
        message = data['message'] as String;
      }
      return Left(ServerFailure(message: message));
    } on Exception catch (e) {
      // For non-Dio exceptions, strip 'Exception: ' prefix if present
      String message = e.toString();
      if (message.startsWith('Exception: ')) {
        message = message.substring('Exception: '.length);
      }
      return Left(ServerFailure(message: message));
    }
  }
}