import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitcoin/features/challenges/data/datasources/challenge_remote_source.dart';
import 'package:fitcoin/features/challenges/data/repositories/challenge_repository_impl.dart';
import 'package:fitcoin/features/challenges/domain/repositories/challenge_repository.dart';
import 'package:fitcoin/features/challenges/domain/usecases/get_challenges.dart';
import 'package:fitcoin/features/challenges/domain/usecases/activate_challenge.dart';
import 'package:fitcoin/features/challenges/domain/usecases/get_active_challenges.dart';
import 'package:fitcoin/features/challenges/domain/usecases/check_progress.dart';
import 'package:fitcoin/features/challenges/domain/usecases/get_history.dart';
import 'package:fitcoin/features/challenges/domain/usecases/create_challenge.dart';
import 'package:fitcoin/features/challenges/domain/usecases/update_challenge.dart';
import 'package:fitcoin/features/challenges/domain/usecases/delete_challenge.dart';
import 'package:fitcoin/features/challenges/presentation/controllers/challenge_controller.dart';
import 'package:fitcoin/features/challenges/presentation/states/challenge_states.dart';

final challengeRemoteSourceProvider = Provider<ChallengeRemoteSource>((ref) {
  return ChallengeRemoteSource();
});

final challengeRepositoryProvider = Provider<ChallengeRepository>((ref) {
  return ChallengeRepositoryImpl(
      remoteSource: ref.watch(challengeRemoteSourceProvider));
});

final getChallengesProvider = Provider<GetChallenges>((ref) {
  return GetChallenges(ref.watch(challengeRepositoryProvider));
});

final activateChallengeProvider = Provider<ActivateChallenge>((ref) {
  return ActivateChallenge(ref.watch(challengeRepositoryProvider));
});

final getActiveChallengesProvider = Provider<GetActiveChallenges>((ref) {
  return GetActiveChallenges(ref.watch(challengeRepositoryProvider));
});

final checkProgressProvider = Provider<CheckProgress>((ref) {
  return CheckProgress(ref.watch(challengeRepositoryProvider));
});

final getHistoryProvider = Provider<GetHistory>((ref) {
  return GetHistory(ref.watch(challengeRepositoryProvider));
});

final createChallengeProvider = Provider<CreateChallenge>((ref) {
  return CreateChallenge(ref.watch(challengeRepositoryProvider));
});

final updateChallengeProvider = Provider<UpdateChallenge>((ref) {
  return UpdateChallenge(ref.watch(challengeRepositoryProvider));
});

final deleteChallengeProvider = Provider<DeleteChallenge>((ref) {
  return DeleteChallenge(ref.watch(challengeRepositoryProvider));
});

final challengeControllerProvider =
StateNotifierProvider<ChallengeController, ChallengesState>((ref) {
  return ChallengeController(
    getChallenges: ref.watch(getChallengesProvider),
    activateChallenge: ref.watch(activateChallengeProvider),
    getActiveChallenges: ref.watch(getActiveChallengesProvider),
    checkProgress: ref.watch(checkProgressProvider),
    getHistory: ref.watch(getHistoryProvider),
    createChallenge: ref.watch(createChallengeProvider),
    updateChallenge: ref.watch(updateChallengeProvider),
    deleteChallenge: ref.watch(deleteChallengeProvider),
  );
});