import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitcoin/features/challenges/domain/entities/challenge.dart';
import 'package:fitcoin/features/challenges/domain/entities/user_challenge.dart';
import 'package:fitcoin/features/challenges/domain/entities/challenge_progress.dart';
import 'package:fitcoin/features/challenges/domain/usecases/get_challenges.dart';
import 'package:fitcoin/features/challenges/domain/usecases/activate_challenge.dart';
import 'package:fitcoin/features/challenges/domain/usecases/get_active_challenges.dart';
import 'package:fitcoin/features/challenges/domain/usecases/check_progress.dart';
import 'package:fitcoin/features/challenges/domain/usecases/get_history.dart';
import 'package:fitcoin/features/challenges/domain/usecases/create_challenge.dart';
import 'package:fitcoin/features/challenges/domain/usecases/update_challenge.dart';
import 'package:fitcoin/features/challenges/domain/usecases/delete_challenge.dart';
import 'package:fitcoin/features/challenges/presentation/states/challenge_states.dart';

class ChallengeController extends StateNotifier<ChallengesState> {
  final GetChallenges _getChallenges;
  final ActivateChallenge _activateChallenge;
  final GetActiveChallenges _getActiveChallenges;
  final CheckProgress _checkProgress;
  final GetHistory _getHistory;
  final CreateChallenge _createChallenge;
  final UpdateChallenge _updateChallenge;
  final DeleteChallenge _deleteChallenge;

  List<Challenge>? _cachedChallenges;
  List<UserChallenge>? _cachedActive;

  ChallengeController({
    required GetChallenges getChallenges,
    required ActivateChallenge activateChallenge,
    required GetActiveChallenges getActiveChallenges,
    required CheckProgress checkProgress,
    required GetHistory getHistory,
    required CreateChallenge createChallenge,
    required UpdateChallenge updateChallenge,
    required DeleteChallenge deleteChallenge,
  })  : _getChallenges = getChallenges,
        _activateChallenge = activateChallenge,
        _getActiveChallenges = getActiveChallenges,
        _checkProgress = checkProgress,
        _getHistory = getHistory,
        _createChallenge = createChallenge,
        _updateChallenge = updateChallenge,
        _deleteChallenge = deleteChallenge,
        super(ChallengesInitial());

  Future<void> loadChallenges() async {
    state = ChallengesLoading(
      cachedChallenges: _cachedChallenges,
      cachedActive: _cachedActive,
    );
    final result = await _getChallenges();
    result.fold(
          (failure) => state = ChallengesError(failure.message),
          (challenges) {
        _cachedChallenges = challenges;
        _loadActiveChallenges();
      },
    );
  }

  Future<void> _loadActiveChallenges() async {
    final result = await _getActiveChallenges();
    result.fold(
          (failure) => state = ChallengesError(failure.message),
          (active) {
        _cachedActive = active;
        state = ChallengesLoaded(
          _cachedChallenges ?? [],
          active,
        );
      },
    );
  }

  Future<void> activateChallenge(int challengeId) async {
    final result = await _activateChallenge(challengeId);
    result.fold(
          (failure) => state = ChallengesError(failure.message),
          (_) => loadChallenges(),
    );
  }

  Future<ChallengeProgress?> checkProgress(int userChallengeId) async {
    final result = await _checkProgress(userChallengeId);
    return result.fold(
          (failure) => null,
          (progress) => progress,
    );
  }

  Future<void> createChallenge({
    required String title,
    String? description,
    required int goalValue,
    required int timeLimitMinutes,
    int rewardFitcoins = 0,
  }) async {
    final result = await _createChallenge(
      title: title,
      description: description,
      goalValue: goalValue,
      timeLimitMinutes: timeLimitMinutes,
      rewardFitcoins: rewardFitcoins,
    );
    result.fold(
          (failure) => state = ChallengesError(failure.message),
          (_) => loadChallenges(),
    );
  }

  Future<void> updateChallenge(
      int id, {
        String? title,
        String? description,
        int? goalValue,
        int? timeLimitMinutes,
        int? rewardFitcoins,
        bool? isActive,
      }) async {
    final result = await _updateChallenge(
      id,
      title: title,
      description: description,
      goalValue: goalValue,
      timeLimitMinutes: timeLimitMinutes,
      rewardFitcoins: rewardFitcoins,
      isActive: isActive,
    );
    result.fold(
          (failure) => state = ChallengesError(failure.message),
          (_) => loadChallenges(),
    );
  }

  Future<void> deleteChallenge(int id) async {
    final result = await _deleteChallenge(id);
    result.fold(
          (failure) => state = ChallengesError(failure.message),
          (_) => loadChallenges(),
    );
  }
}