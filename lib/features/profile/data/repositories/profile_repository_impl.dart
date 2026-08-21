import 'package:dartz/dartz.dart';
import 'package:fitcoin/core/error/failures.dart';
import 'package:fitcoin/features/profile/domain/entities/user_profile.dart';
import 'package:fitcoin/features/profile/domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteSource remoteSource;

  ProfileRepositoryImpl({required this.remoteSource});

  @override
  Future<Either<Failure, UserProfile>> getProfile() async {
    try {
      final profile = await remoteSource.getProfile();
      return Right(profile);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserProfile>> updateProfile({
    String? firstName,
    String? lastName,
    String? username,
    String? phone,
  }) async {
    try {
      final profile = await remoteSource.updateProfile(
        firstName: firstName,
        lastName: lastName,
        username: username,
        phone: phone,
      );
      return Right(profile);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserProfile>> uploadAvatar(String filePath) async {
    try {
      final profile = await remoteSource.uploadAvatar(filePath);
      return Right(profile);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}