import 'package:dartz/dartz.dart';
import 'package:fitcoin/core/error/failures.dart';
import '../entities/user_profile.dart';
import '../repositories/profile_repository.dart';

class UploadAvatar {
  final ProfileRepository repository;
  UploadAvatar(this.repository);
  Future<Either<Failure, UserProfile>> call(String filePath) =>
      repository.uploadAvatar(filePath);
}