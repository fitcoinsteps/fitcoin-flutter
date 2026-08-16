import 'package:dartz/dartz.dart';
import 'package:fitcoin/core/error/failures.dart';

abstract class LogoutRepository {
  Future<Either<Failure, String>> logout();
  Future<Either<Failure, String>> logoutAllDevices();
}