import 'package:dio/dio.dart';
import 'package:fitcoin/core/network/dio_client.dart';
import 'package:fitcoin/features/step_counter/data/models/step_data_model.dart';

class StepRemoteSource {
  final Dio dio;

  StepRemoteSource() : dio = DioClient().dio;

  Future<StepDataModel> syncSteps(StepDataModel stepData) async {
    try {
      print('🔄 Syncing steps: ${stepData.toJson()}');
      final response = await dio.post('/steps', data: stepData.toJson());
      print('✅ Sync response: ${response.data}');
      if (response.statusCode == 200) {
        return StepDataModel.fromJson(response.data);
      } else {
        throw Exception('Failed to sync steps');
      }
    } on DioException catch (e) {
      print('❌ Sync error: ${e.response?.data}');
      throw Exception(e.response?.data['message'] ?? 'Sync failed');
    }
  }

  Future<StepDataModel> getTodaySteps() async {
    try {
      print('🔄 Fetching today steps...');
      final response = await dio.get('/steps/today');
      print('✅ Fetch response: ${response.data}');
      if (response.statusCode == 200) {
        return StepDataModel.fromJson(response.data);
      } else {
        throw Exception('Failed to fetch steps');
      }
    } on DioException catch (e) {
      print('❌ Fetch error: ${e.response?.data}');
      throw Exception(e.response?.data['message'] ?? 'Fetch failed');
    }
  }

  Future<void> updateGoal(int goal) async {
    try {
      final response = await dio.post('/steps/goal', data: {'goal': goal});
      if (response.statusCode != 200) {
        throw Exception('Failed to update goal');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Goal update failed');
    }
  }
}