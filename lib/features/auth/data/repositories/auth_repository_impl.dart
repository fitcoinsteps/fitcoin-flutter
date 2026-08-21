import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:fitcoin/core/error/failures.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/models/registration_response.dart';
import '../../presentation/states/auth_states.dart'; // for OtpVerificationResult
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
        return Left(ServerFailure(
          message: e.response?.data['message'] ??
              e.message ??
              'Registration failed',
        ));
      }
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, OtpVerificationResult>> verifyOtp({
    required String email,
    required String code,
  }) async {
    try {
      final result = await remoteDataSource.verifyOtp(
        email: email,
        code: code,
      );
      return Right(result);
    } on Exception catch (e) {
      if (e is DioException) {
        return Left(ServerFailure(
          message: e.response?.data['message'] ??
              e.message ??
              'Verification failed',
        ));
      }
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> resendOtp({required String email}) async {
    try {
      final message = await remoteDataSource.resendOtp(email: email);
      return Right(message);
    } on Exception catch (e) {
      if (e is DioException) {
        return Left(ServerFailure(
          message: e.response?.data['message'] ?? 'Failed to resend OTP',
        ));
      }
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // ==================== Additional concrete methods (not in interface) ====================

  /// Log out user and clear local cache.
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      return const Right(null);
    } on Exception {
      // Even if API fails, we still want to clear local cache.
      return const Right(null);
    }
  }

  /// Check if the user is authenticated and token is not expired.
  bool isAuthenticated() {
    return remoteDataSource.isAuthenticated();
  }

  /// Refresh the access token.
  Future<Either<Failure, String>> refreshToken() async {
    try {
      final token = await remoteDataSource.refreshToken();
      if (token != null) {
        return Right(token);
      } else {
        return Left(ServerFailure(message: 'Failed to refresh token'));
      }
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}