import 'package:dio/dio.dart';
import 'package:fitcoin/core/network/dio_client.dart';
import 'package:fitcoin/features/step_counter/data/models/step_data_model.dart';

class StepRemoteSource {
  final Dio dio;

  StepRemoteSource() : dio = DioClient().dio;

  Future<StepDataModel> syncSteps(StepDataModel stepData) async {
    try {
      final response = await dio.post('/steps', data: stepData.toJson());
      if (response.statusCode == 200) {
        return StepDataModel.fromJson(response.data);
      } else {
        throw Exception('Failed to sync steps');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Sync failed');
    }
  }

  Future<StepDataModel> getTodaySteps() async {
    try {
      final response = await dio.get('/steps/today');
      if (response.statusCode == 200) {
        return StepDataModel.fromJson(response.data);
      } else {
        throw Exception('Failed to fetch steps');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Fetch failed');
    }
  }
}