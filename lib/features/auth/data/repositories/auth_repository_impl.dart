import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:fitcoin/core/error/failures.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/models/registration_response.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/register_request_model.dart';
import '../mappers/user_mapper.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, RegistrationResponse>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? phone,
  }) async {
    try {
      final request = RegisterRequest(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
        phone: phone,
      );

      final response = await remoteDataSource.register(request);
      return Right(response);
    } on Exception catch (e) {
      if (e is DioException) {
        return Left(e.toFailure());
      }
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> verifyOtp({
    required String email,
    required String code, // ✅ Changed from 'otp' to 'code'
  }) async {
    try {
      final userModel = await remoteDataSource.verifyOtp(
        email: email,
        code: code, // ✅ Changed from 'otp' to 'code'
      );

      final userEntity = UserMapper.toEntity(userModel);
      return Right(userEntity);
    } on Exception catch (e) {
      if (e is DioException) {
        return Left(e.toFailure());
      }
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> resendOtp({
    required String email,
  }) async {
    try {
      final message = await remoteDataSource.resendOtp(email: email);
      return Right(message);
    } on Exception catch (e) {
      if (e is DioException) {
        return Left(e.toFailure());
      }
      return Left(ServerFailure(message: e.toString()));
    }
  }
}