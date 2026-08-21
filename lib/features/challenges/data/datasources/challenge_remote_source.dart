import 'package:dio/dio.dart';
import 'package:fitcoin/core/network/dio_client.dart';
import 'package:fitcoin/features/challenges/data/models/challenge_model.dart';
import 'package:fitcoin/features/challenges/data/models/user_challenge_model.dart';
import 'package:fitcoin/features/challenges/data/models/challenge_progress_model.dart';

class ChallengeRemoteSource {
  final Dio _dio;

  ChallengeRemoteSource() : _dio = DioClient().dio;

  Future<List<ChallengeModel>> getChallenges() async {
    final response = await _dio.get('/challenges');
    final data = response.data as Map<String, dynamic>;
    final list = data['challenges'] as List<dynamic>? ?? [];
    return list.map((item) => ChallengeModel.fromJson(item)).toList();
  }

  Future<ChallengeModel> createChallenge({
    required String title,
    String? description,
    required int goalValue,
    required int timeLimitMinutes,
    int rewardFitcoins = 0,
  }) async {
    final response = await _dio.post('/challenges', data: {
      'title': title,
      'description': description,
      'goal_type': 'steps',
      'goal_value': goalValue,
      'time_limit_minutes': timeLimitMinutes,
      'reward_fitcoins': rewardFitcoins,
      'is_active': true,
    });
    return ChallengeModel.fromJson(response.data);
  }

  Future<ChallengeModel> updateChallenge(
      int id, {
        String? title,
        String? description,
        int? goalValue,
        int? timeLimitMinutes,
        int? rewardFitcoins,
        bool? isActive,
      }) async {
    final data = <String, dynamic>{};
    if (title != null) data['title'] = title;
    if (description != null) data['description'] = description;
    if (goalValue != null) data['goal_value'] = goalValue;
    if (timeLimitMinutes != null) data['time_limit_minutes'] = timeLimitMinutes;
    if (rewardFitcoins != null) data['reward_fitcoins'] = rewardFitcoins;
    if (isActive != null) data['is_active'] = isActive;

    final response = await _dio.put('/challenges/$id', data: data);
    return ChallengeModel.fromJson(response.data);
  }

  Future<void> deleteChallenge(int id) async {
    await _dio.delete('/challenges/$id');
  }

  Future<void> activateChallenge(int challengeId) async {
    await _dio.post('/challenges/$challengeId/activate');
  }

  Future<List<UserChallengeModel>> getActiveChallenges() async {
    final response = await _dio.get('/challenges/active');
    final data = response.data as Map<String, dynamic>;
    final list = data['active_challenges'] as List<dynamic>? ?? [];
    return list.map((item) => UserChallengeModel.fromJson(item)).toList();
  }

  Future<ChallengeProgressModel> checkProgress(int userChallengeId) async {
    final response = await _dio.get('/challenges/$userChallengeId/progress');
    return ChallengeProgressModel.fromJson(response.data);
  }

  Future<List<Map<String, dynamic>>> getHistory() async {
    final response = await _dio.get('/challenges/history');
    final data = response.data as Map<String, dynamic>;
    final list = data['history'] as List<dynamic>? ?? [];
    return list.map((item) => item as Map<String, dynamic>).toList();
  }
}