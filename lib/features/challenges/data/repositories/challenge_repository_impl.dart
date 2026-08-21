import 'package:dartz/dartz.dart';
import 'package:fitcoin/core/error/failures.dart';
import 'package:fitcoin/features/challenges/domain/entities/challenge.dart';
import 'package:fitcoin/features/challenges/domain/entities/user_challenge.dart';
import 'package:fitcoin/features/challenges/domain/entities/challenge_progress.dart';
import 'package:fitcoin/features/challenges/domain/repositories/challenge_repository.dart';
import '../datasources/challenge_remote_source.dart';

class ChallengeRepositoryImpl implements ChallengeRepository {
  final ChallengeRemoteSource remoteSource;

  ChallengeRepositoryImpl({required this.remoteSource});

  @override
  Future<Either<Failure, List<Challenge>>> getChallenges() async {
    try {
      final challenges = await remoteSource.getChallenges();
      return Right(challenges);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Challenge>> createChallenge({
    required String title,
    String? description,
    required int goalValue,
    required int timeLimitMinutes,
    int rewardFitcoins = 0,
  }) async {
    try {
      final challenge = await remoteSource.createChallenge(
        title: title,
        description: description,
        goalValue: goalValue,
        timeLimitMinutes: timeLimitMinutes,
        rewardFitcoins: rewardFitcoins,
      );
      return Right(challenge);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Challenge>> updateChallenge(
      int id, {
        String? title,
        String? description,
        int? goalValue,
        int? timeLimitMinutes,
        int? rewardFitcoins,
        bool? isActive,
      }) async {
    try {
      final challenge = await remoteSource.updateChallenge(
        id,
        title: title,
        description: description,
        goalValue: goalValue,
        timeLimitMinutes: timeLimitMinutes,
        rewardFitcoins: rewardFitcoins,
        isActive: isActive,
      );
      return Right(challenge);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteChallenge(int id) async {
    try {
      await remoteSource.deleteChallenge(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> activateChallenge(int challengeId) async {
    try {
      await remoteSource.activateChallenge(challengeId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<UserChallenge>>> getActiveChallenges() async {
    try {
      final active = await remoteSource.getActiveChallenges();
      return Right(active);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ChallengeProgress>> checkProgress(
      int userChallengeId) async {
    try {
      final progress = await remoteSource.checkProgress(userChallengeId);
      return Right(progress);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getHistory() async {
    try {
      final history = await remoteSource.getHistory();
      return Right(history);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}