import 'package:dartz/dartz.dart';
import 'package:fitcoin/core/error/failures.dart';
import '../entities/user_profile.dart';

abstract class ProfileRepository {
  Future<Either<Failure, UserProfile>> getProfile();
  Future<Either<Failure, UserProfile>> updateProfile({
    String? firstName,
    String? lastName,
    String? username,
    String? phone,
  });
  Future<Either<Failure, UserProfile>> uploadAvatar(String filePath);
}