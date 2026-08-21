import 'package:dartz/dartz.dart';
import 'package:fitcoin/core/error/failures.dart';
import '../entities/challenge.dart';
import '../repositories/challenge_repository.dart';

class UpdateChallenge {
  final ChallengeRepository repository;
  UpdateChallenge(this.repository);

  Future<Either<Failure, Challenge>> call(
      int id, {
        String? title,
        String? description,
        int? goalValue,
        int? timeLimitMinutes,
        int? rewardFitcoins,
        bool? isActive,
      }) => repository.updateChallenge(
    id,
    title: title,
    description: description,
    goalValue: goalValue,
    timeLimitMinutes: timeLimitMinutes,
    rewardFitcoins: rewardFitcoins,
    isActive: isActive,
  );
}