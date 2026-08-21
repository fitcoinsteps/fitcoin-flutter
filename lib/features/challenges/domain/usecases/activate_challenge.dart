import 'package:dartz/dartz.dart';
import 'package:fitcoin/core/error/failures.dart';
import '../repositories/challenge_repository.dart';

class ActivateChallenge {
  final ChallengeRepository repository;
  ActivateChallenge(this.repository);
  Future<Either<Failure, void>> call(int challengeId) =>
      repository.activateChallenge(challengeId);
}