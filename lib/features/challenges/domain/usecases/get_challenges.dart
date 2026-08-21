import 'package:dartz/dartz.dart';
import 'package:fitcoin/core/error/failures.dart';
import '../entities/challenge.dart';
import '../repositories/challenge_repository.dart';

class GetChallenges {
  final ChallengeRepository repository;
  GetChallenges(this.repository);
  Future<Either<Failure, List<Challenge>>> call() => repository.getChallenges();
}