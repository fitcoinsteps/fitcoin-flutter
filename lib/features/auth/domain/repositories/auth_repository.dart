import 'package:dartz/dartz.dart';
import 'package:fitcoin/core/error/failures.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/models/registration_response.dart';

abstract class AuthRepository {
  Future<Either<Failure, RegistrationResponse>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? phone,
  });

  Future<Either<Failure, UserEntity>> verifyOtp({
    required String email,
    required String code, // ✅ Changed from 'otp' to 'code'
  });

  Future<Either<Failure, String>> resendOtp({required String email});
}