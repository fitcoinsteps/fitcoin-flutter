import 'package:dartz/dartz.dart';
import 'package:fitcoin/core/error/failures.dart';
import '../entities/challenge.dart';
import '../repositories/challenge_repository.dart';

class CreateChallenge {
  final ChallengeRepository repository;
  CreateChallenge(this.repository);

  Future<Either<Failure, Challenge>> call({
    required String title,
    String? description,
    required int goalValue,
    required int timeLimitMinutes,
    int rewardFitcoins = 0,
  }) => repository.createChallenge(
    title: title,
    description: description,
    goalValue: goalValue,
    timeLimitMinutes: timeLimitMinutes,
    rewardFitcoins: rewardFitcoins,
  );
}