import 'package:dartz/dartz.dart';
import 'package:fitcoin/core/error/failures.dart';
import '../entities/user_challenge.dart';
import '../repositories/challenge_repository.dart';

class GetActiveChallenges {
  final ChallengeRepository repository;
  GetActiveChallenges(this.repository);
  Future<Either<Failure, List<UserChallenge>>> call() =>
      repository.getActiveChallenges();
}