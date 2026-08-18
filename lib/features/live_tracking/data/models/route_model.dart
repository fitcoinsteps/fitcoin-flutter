import 'package:fitcoin/features/live_tracking/data/models/location_point_model.dart';

class RouteModel {
  final List<LocationPointModel> points;
  final double distanceMeters;
  final double durationSeconds;

  RouteModel({
    required this.points,
    required this.distanceMeters,
    required this.durationSeconds,
  });

  factory RouteModel.fromJson(Map<String, dynamic> json) => RouteModel(
    points: (json['points'] as List)
        .map((p) => LocationPointModel.fromJson(p))
        .toList(),
    distanceMeters: json['distance_meters'],
    durationSeconds: json['duration_seconds'],
  );

  Map<String, dynamic> toJson() => {
    'points': points.map((p) => p.toJson()).toList(),
    'distance_meters': distanceMeters,
    'duration_seconds': durationSeconds,
  };
}