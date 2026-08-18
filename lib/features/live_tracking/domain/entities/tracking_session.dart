import 'package:fitcoin/features/live_tracking/domain/entities/location_point.dart';
import 'package:fitcoin/features/live_tracking/domain/entities/route.dart';

class TrackingSession {
  final String id;
  final LocationPoint startLocation;
  final LocationPoint? endLocation;
  final RouteInfo? route;
  final DateTime startedAt;
  final DateTime? endedAt;
  final bool isActive;

  TrackingSession({
    required this.id,
    required this.startLocation,
    this.endLocation,
    this.route,
    required this.startedAt,
    this.endedAt,
    this.isActive = true,
  });
}