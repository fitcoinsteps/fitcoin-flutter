import 'package:dartz/dartz.dart';
import 'package:fitcoin/core/error/failures.dart';
import '../entities/challenge_progress.dart';
import '../repositories/challenge_repository.dart';

class CheckProgress {
  final ChallengeRepository repository;
  CheckProgress(this.repository);
  Future<Either<Failure, ChallengeProgress>> call(int userChallengeId) =>
      repository.checkProgress(userChallengeId);
}