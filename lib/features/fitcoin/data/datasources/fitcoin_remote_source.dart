import 'package:dio/dio.dart';
import 'package:fitcoin/core/network/dio_client.dart';
import 'package:fitcoin/features/fitcoin/domain/entities/fitcoin_balance.dart';
import 'package:fitcoin/features/fitcoin/domain/entities/fitcoin_convert_result.dart';

class FitcoinRemoteSource {
  final Dio _dio;

  FitcoinRemoteSource() : _dio = DioClient().dio;

  Future<FitcoinBalance> getBalance() async {
    try {
      final response = await _dio.get('/fitcoin/balance');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return FitcoinBalance(
          fitcoinBalance: response.data['fitcoin_balance'] ?? 0,
          todayAvailableSteps: response.data['today_available_steps'] ?? 0,
          conversionRate: int.parse(response.data['conversion_rate'].toString()),
        );
      } else {
        throw Exception(response.data['message'] ?? 'Failed to load balance');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<FitcoinConvertResult> convertSteps(int stepsToConvert) async {
    try {
      final response = await _dio.post(
        '/fitcoin/convert',
        data: {'steps_to_convert': stepsToConvert},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return FitcoinConvertResult(
          fitcoinsEarned: response.data['fitcoins_earned'] ?? 0,
          remainingSteps: response.data['remaining_steps'] ?? 0,
          conversionRate: int.parse(response.data['conversion_rate'].toString()),
          fitcoinBalance: response.data['fitcoin_balance'] ?? 0,
        );
      } else {
        throw Exception(response.data['message'] ?? 'Conversion failed');
      }
    } catch (e) {
      rethrow;
    }
  }
}