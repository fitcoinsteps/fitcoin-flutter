import 'package:dartz/dartz.dart';
import 'package:fitcoin/core/error/failures.dart';
import '../entities/challenge.dart';
import '../entities/user_challenge.dart';
import '../entities/challenge_progress.dart';

abstract class ChallengeRepository {
  Future<Either<Failure, List<Challenge>>> getChallenges();

  Future<Either<Failure, Challenge>> createChallenge({
    required String title,
    String? description,
    required int goalValue,
    required int timeLimitMinutes,
    int rewardFitcoins = 0,
  });

  Future<Either<Failure, Challenge>> updateChallenge(
      int id, {
        String? title,
        String? description,
        int? goalValue,
        int? timeLimitMinutes,
        int? rewardFitcoins,
        bool? isActive,
      });

  Future<Either<Failure, void>> deleteChallenge(int id);

  Future<Either<Failure, void>> activateChallenge(int challengeId);
  Future<Either<Failure, List<UserChallenge>>> getActiveChallenges();
  Future<Either<Failure, ChallengeProgress>> checkProgress(int userChallengeId);
  Future<Either<Failure, List<Map<String, dynamic>>>> getHistory();
}