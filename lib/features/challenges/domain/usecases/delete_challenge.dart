import 'package:dartz/dartz.dart';
import 'package:fitcoin/core/error/failures.dart';
import '../repositories/challenge_repository.dart';

class DeleteChallenge {
  final ChallengeRepository repository;
  DeleteChallenge(this.repository);

  Future<Either<Failure, void>> call(int id) =>
      repository.deleteChallenge(id);
}