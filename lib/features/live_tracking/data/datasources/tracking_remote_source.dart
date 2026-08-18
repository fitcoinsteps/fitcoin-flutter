import 'package:dio/dio.dart';
import 'package:fitcoin/core/network/dio_client.dart';
import 'package:fitcoin/features/live_tracking/data/models/tracking_session_model.dart';

class TrackingRemoteSource {
  final Dio dio;

  TrackingRemoteSource() : dio = DioClient().dio;

  Future<void> saveTrackingSession(TrackingSessionModel session) async {
    try {
      final response = await dio.post('/tracking-sessions', data: {
        'started_at': session.startedAt.toIso8601String(),
        'ended_at': session.endedAt?.toIso8601String(),
        'start_lat': session.startLocation.latitude,
        'start_lng': session.startLocation.longitude,
        'end_lat': session.endLocation?.latitude,
        'end_lng': session.endLocation?.longitude,
        'distance_meters': session.route?.distanceMeters ?? 0,
        'duration_seconds': session.route?.durationSeconds ?? 0,
      });
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to save tracking session');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Save failed');
    }
  }
}