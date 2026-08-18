import 'package:fitcoin/features/live_tracking/data/models/location_point_model.dart';
import 'package:fitcoin/features/live_tracking/data/models/route_model.dart';

class TrackingSessionModel {
  final String id;
  final LocationPointModel startLocation;
  final LocationPointModel? endLocation;
  final RouteModel? route;
  final DateTime startedAt;
  final DateTime? endedAt;
  final bool isActive;

  TrackingSessionModel({
    required this.id,
    required this.startLocation,
    this.endLocation,
    this.route,
    required this.startedAt,
    this.endedAt,
    this.isActive = true,
  });

  factory TrackingSessionModel.fromJson(Map<String, dynamic> json) =>
      TrackingSessionModel(
        id: json['id'],
        startLocation: LocationPointModel.fromJson(json['start_location']),
        endLocation: json['end_location'] != null
            ? LocationPointModel.fromJson(json['end_location'])
            : null,
        route:
        json['route'] != null ? RouteModel.fromJson(json['route']) : null,
        startedAt: DateTime.parse(json['started_at']),
        endedAt:
        json['ended_at'] != null ? DateTime.parse(json['ended_at']) : null,
        isActive: json['is_active'] ?? true,
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'start_location': startLocation.toJson(),
    'end_location': endLocation?.toJson(),
    'route': route?.toJson(),
    'started_at': startedAt.toIso8601String(),
    'ended_at': endedAt?.toIso8601String(),
    'is_active': isActive,
  };
}