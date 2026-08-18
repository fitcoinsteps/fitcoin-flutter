import 'package:dio/dio.dart';
import 'package:fitcoin/core/config/app_config.dart';
import 'package:fitcoin/features/live_tracking/domain/entities/location_point.dart';
import 'package:fitcoin/features/live_tracking/domain/entities/route.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class DirectionsDataSource {
  final Dio dio;

  DirectionsDataSource() : dio = Dio(); // Use standalone Dio for external API

  Future<RouteInfo> getDirections({
    required LocationPoint origin,
    required LocationPoint destination,
  }) async {
    final apiKey = AppConfig.current.googleMapsApiKey;
    final url = 'https://routes.googleapis.com/directions/v2:computeRoutes';

    final response = await dio.post(
      url,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'X-Goog-Api-Key': apiKey,
          'X-Goog-FieldMask': 'routes.duration,routes.distanceMeters,routes.polyline.encodedPolyline',
          'X-Android-Package': 'app.fitcoin.com',
          'X-Android-Cert': '0D:18:EE:00:E2:7D:23:4E:0C:28:73:D9:DD:D0:48:ED:BB:CC:78:1F',

        },
      ),
      data: {
        'origin': {
          'location': {
            'latLng': {
              'latitude': origin.latitude,
              'longitude': origin.longitude,
            },
          },
        },
        'destination': {
          'location': {
            'latLng': {
              'latitude': destination.latitude,
              'longitude': destination.longitude,
            },
          },
        },
        'travelMode': 'WALK',
      },
    );

    if (response.statusCode == 200 && response.data != null) {
      final data = response.data as Map<String, dynamic>;
      final routes = data['routes'] as List?;
      if (routes != null && routes.isNotEmpty) {
        final route = routes.first;
        final distanceMeters = (route['distanceMeters'] as num?)?.toDouble() ?? 0.0;
        final durationString = route['duration'] as String? ?? '0s';
        final polyline = route['polyline']?['encodedPolyline'] as String? ?? '';

        final durationSeconds = _parseDuration(durationString);
        final points = _decodePolyline(polyline);

        return RouteInfo(
          points: points,
          distanceMeters: distanceMeters,
          durationSeconds: durationSeconds,
        );
      }
    }
    throw Exception('Failed to get directions');
  }

  List<LocationPoint> _decodePolyline(String encoded) {
    final polylinePoints = PolylinePoints();
    final decoded = polylinePoints.decodePolyline(encoded);
    return decoded
        .map((p) => LocationPoint(
      latitude: p.latitude,
      longitude: p.longitude,
      timestamp: DateTime.now(),
    ))
        .toList();
  }

  double _parseDuration(String duration) {
    // Remove 's' suffix and convert to double
    final seconds = int.tryParse(duration.replaceAll('s', '')) ?? 0;
    return seconds.toDouble();
  }
}