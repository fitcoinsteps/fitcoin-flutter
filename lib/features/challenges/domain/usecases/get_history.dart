import 'package:dartz/dartz.dart';
import 'package:fitcoin/core/error/failures.dart';
import '../repositories/challenge_repository.dart';

class GetHistory {
  final ChallengeRepository repository;
  GetHistory(this.repository);
  Future<Either<Failure, List<Map<String, dynamic>>>> call() =>
      repository.getHistory();
}