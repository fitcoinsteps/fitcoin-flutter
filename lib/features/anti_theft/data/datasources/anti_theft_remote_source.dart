import 'package:dio/dio.dart';
import 'package:fitcoin/core/network/dio_client.dart';
import 'package:fitcoin/features/anti_theft/data/models/theft_alert.dart';

class AntiTheftRemoteSource {
  final Dio dio;

  AntiTheftRemoteSource() : dio = DioClient().dio;

  Future<void> sendTheftAlert(TheftAlertModel alert) async {
    await dio.post('/theft-alerts', data: alert.toJson());
  }
}