import 'package:fitcoin/features/live_tracking/domain/entities/location_point.dart';

class RouteInfo {
  final List<LocationPoint> points;
  final double distanceMeters;
  final double durationSeconds;

  RouteInfo({
    required this.points,
    required this.distanceMeters,
    required this.durationSeconds,
  });
}