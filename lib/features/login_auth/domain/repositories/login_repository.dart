import 'package:dartz/dartz.dart';
import 'package:fitcoin/core/error/failures.dart';
import '../models/login_response.dart';

abstract class LoginRepository {
  Future<Either<Failure, LoginResponse>> login({
    required String email,
    required String password,
  });
}