import 'package:equatable/equatable.dart';
import 'package:dio/dio.dart';

abstract class Failure extends Equatable {
  final String message;
  final int? statusCode;
  final String? stackTrace;

  const Failure({required this.message, this.statusCode, this.stackTrace});

  @override
  List<Object?> get props => [message, statusCode];
}

class NetworkFailure extends Failure {
  const NetworkFailure({
    required super.message,
    super.statusCode,
    super.stackTrace,
  });
}

class TimeoutFailure extends Failure {
  const TimeoutFailure({
    required super.message,
    super.statusCode,
    super.stackTrace,
  });
}

abstract class AuthFailure extends Failure {
  const AuthFailure({
    required super.message,
    super.statusCode,
    super.stackTrace,
  });
}

class OtpFailure extends AuthFailure {
  const OtpFailure({
    required super.message,
    super.statusCode,
    super.stackTrace,
  });
}

class RegistrationFailure extends AuthFailure {
  const RegistrationFailure({
    required super.message,
    super.statusCode,
    super.stackTrace,
  });
}

class TokenExpiredFailure extends AuthFailure {
  const TokenExpiredFailure({
    super.message = 'Session expired. Please login again.',
    super.statusCode = 401,
    super.stackTrace,
  });
}

class ValidationFailure extends Failure {
  const ValidationFailure({required super.message, super.stackTrace});
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message, super.stackTrace});
}

class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    super.statusCode,
    super.stackTrace,
  });
}

class InternalServerFailure extends ServerFailure {
  const InternalServerFailure({
    required super.message,
    super.statusCode = 500,
    super.stackTrace,
  });
}

extension DioExceptionToFailure on DioException {
  Failure toFailure() {
    switch (type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutFailure(
          message: 'Connection timeout. Please try again.',
          statusCode: response?.statusCode,
        );

      case DioExceptionType.connectionError:
        return NetworkFailure(
          message: 'No internet connection.',
          statusCode: response?.statusCode,
        );

      case DioExceptionType.badResponse:
        final statusCode = response?.statusCode;
        final message = response?.data['message'] ?? 'Server error';

        if (statusCode == 401) {
          return TokenExpiredFailure(statusCode: statusCode);
        } else if (statusCode == 422) {
          return ValidationFailure(message: message);
        } else if (statusCode != null && statusCode >= 500) {
          return InternalServerFailure(
            message: message,
            statusCode: statusCode,
          );
        }

        return ServerFailure(
          message: message,
          statusCode: statusCode,
        );

      default:
        return ServerFailure(
          message: message ?? 'An error occurred',
        );
    }
  }
}