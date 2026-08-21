import 'package:fitcoin/features/challenges/domain/entities/challenge.dart';
import 'package:fitcoin/features/challenges/domain/entities/user_challenge.dart';

sealed class ChallengesState {}

class ChallengesInitial extends ChallengesState {}

class ChallengesLoading extends ChallengesState {
  final List<Challenge>? cachedChallenges;
  final List<UserChallenge>? cachedActive;
  ChallengesLoading({this.cachedChallenges, this.cachedActive});
}

class ChallengesLoaded extends ChallengesState {
  final List<Challenge> availableChallenges;
  final List<UserChallenge> activeChallenges;
  ChallengesLoaded(this.availableChallenges, this.activeChallenges);
}

class ChallengesError extends ChallengesState {
  final String message;
  ChallengesError(this.message);
}