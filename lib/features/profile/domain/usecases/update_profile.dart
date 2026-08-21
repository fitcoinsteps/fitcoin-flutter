import 'package:dartz/dartz.dart';
import 'package:fitcoin/core/error/failures.dart';
import '../entities/user_profile.dart';
import '../repositories/profile_repository.dart';

class UpdateProfile {
  final ProfileRepository repository;
  UpdateProfile(this.repository);
  Future<Either<Failure, UserProfile>> call({
    String? firstName,
    String? lastName,
    String? username,
    String? phone,
  }) => repository.updateProfile(
    firstName: firstName,
    lastName: lastName,
    username: username,
    phone: phone,
  );
}