import 'package:dio/dio.dart';
import 'package:fitcoin/core/network/dio_client.dart';
import 'package:fitcoin/features/fitcoin/data/models/fitcoin_balance_model.dart';
import 'package:fitcoin/features/fitcoin/data/models/fitcoin_convert_response_model.dart';

class FitcoinRemoteSource {
  final Dio dio;

  FitcoinRemoteSource() : dio = DioClient().dio;

  Future<FitcoinBalanceModel> getBalance() async {
    try {
      final response = await dio.get('/fitcoins/balance');
      if (response.statusCode == 200) {
        return FitcoinBalanceModel.fromJson(response.data);
      } else {
        throw Exception('Failed to load balance');
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['error'] ??
            e.response?.data['message'] ??
            'Failed to load balance',
      );
    }
  }

  Future<FitcoinConvertResponseModel> convertSteps(int stepsToConvert) async {
    try {
      final response = await dio.post(
        '/fitcoins/convert',
        data: {'steps_to_convert': stepsToConvert},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return FitcoinConvertResponseModel.fromJson(response.data);
      } else {
        throw Exception('Failed to convert steps');
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['error'] ??
            e.response?.data['message'] ??
            'Failed to convert steps',
      );
    }
  }
}