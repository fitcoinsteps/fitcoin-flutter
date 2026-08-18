import 'dart:async';
import 'dart:math' as Math;
import 'package:dartz/dartz.dart';
import 'package:fitcoin/core/error/failures.dart';
import 'package:fitcoin/features/live_tracking/data/models/location_point_model.dart';
import 'package:fitcoin/features/live_tracking/data/models/route_model.dart';
import 'package:fitcoin/features/live_tracking/data/models/tracking_session_model.dart';
import 'package:fitcoin/features/live_tracking/data/datasources/directions_data_source.dart';
import 'package:fitcoin/features/live_tracking/data/datasources/location_data_source.dart';
import 'package:fitcoin/features/live_tracking/data/datasources/tracking_remote_source.dart';
import 'package:fitcoin/features/live_tracking/domain/entities/location_point.dart';
import 'package:fitcoin/features/live_tracking/domain/entities/route.dart';
import 'package:fitcoin/features/live_tracking/domain/entities/tracking_session.dart';
import 'package:fitcoin/features/live_tracking/domain/repositories/tracking_repository.dart';

class TrackingRepositoryImpl implements TrackingRepository {
  final LocationDataSource locationDataSource;
  final DirectionsDataSource directionsDataSource;
  final TrackingRemoteSource remoteSource;

  List<LocationPoint> _trackedPoints = [];
  TrackingSession? _activeSession;

  TrackingRepositoryImpl({
    required this.locationDataSource,
    required this.directionsDataSource,
    required this.remoteSource,
  });

  @override
  Future<Either<Failure, LocationPoint>> getCurrentLocation() async {
    try {
      final loc = await locationDataSource.getCurrentLocation();
      return Right(loc);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Stream<LocationPoint> getLocationStream() {
    return locationDataSource.getLocationStream();
  }

  @override
  Future<Either<Failure, RouteInfo>> getDirections({
    required LocationPoint origin,
    required LocationPoint destination,
  }) async {
    try {
      final route = await directionsDataSource.getDirections(
          origin: origin, destination: destination);
      return Right(route);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveTrackingSession(TrackingSession session) async {
    try {
      final model = TrackingSessionModel(
        id: session.id,
        startLocation: _toLocationPointModel(session.startLocation),
        endLocation: session.endLocation != null
            ? _toLocationPointModel(session.endLocation!)
            : null,
        route: session.route != null
            ? _toRouteModel(session.route!)
            : null,
        startedAt: session.startedAt,
        endedAt: session.endedAt,
        isActive: session.isActive,
      );
      await remoteSource.saveTrackingSession(model);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  LocationPointModel _toLocationPointModel(LocationPoint point) {
    return LocationPointModel(
      latitude: point.latitude,
      longitude: point.longitude,
      timestamp: point.timestamp,
    );
  }

  RouteModel _toRouteModel(RouteInfo route) {
    return RouteModel(
      points: route.points
          .map((p) => LocationPointModel(
        latitude: p.latitude,
        longitude: p.longitude,
        timestamp: p.timestamp,
      ))
          .toList(),
      distanceMeters: route.distanceMeters,
      durationSeconds: route.durationSeconds,
    );
  }

  @override
  Stream<TrackingSession> startTracking(LocationPoint start) {
    _trackedPoints = [start];
    _activeSession = TrackingSession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      startLocation: start,
      startedAt: DateTime.now(),
      isActive: true,
    );

    return locationDataSource.getLocationStream().map((loc) {
      _trackedPoints.add(loc);
      _activeSession = TrackingSession(
        id: _activeSession!.id,
        startLocation: _activeSession!.startLocation,
        startedAt: _activeSession!.startedAt,
        isActive: true,
      );
      return _activeSession!;
    });
  }

  @override
  Future<Either<Failure, TrackingSession>> stopTracking() async {
    if (_activeSession == null) {
      return Left(ServerFailure(message: 'No active tracking session.'));
    }

    final start = _activeSession!.startLocation;
    final end = _trackedPoints.isNotEmpty ? _trackedPoints.last : start;
    final distanceMeters = _calculateDistance(_trackedPoints);
    final durationSeconds = DateTime.now()
        .difference(_activeSession!.startedAt)
        .inSeconds
        .toDouble();

    final session = TrackingSession(
      id: _activeSession!.id,
      startLocation: start,
      endLocation: end,
      startedAt: _activeSession!.startedAt,
      endedAt: DateTime.now(),
      isActive: false,
      route: RouteInfo(
        points: _trackedPoints,
        distanceMeters: distanceMeters,
        durationSeconds: durationSeconds,
      ),
    );
    _activeSession = null;
    return Right(session);
  }

  // Haversine distance between consecutive points, sum them
  double _calculateDistance(List<LocationPoint> points) {
    if (points.length < 2) return 0.0;
    double total = 0.0;
    for (int i = 0; i < points.length - 1; i++) {
      total += _distanceBetween(points[i], points[i + 1]);
    }
    return total;
  }

  double _distanceBetween(LocationPoint a, LocationPoint b) {
    const earthRadius = 6371000; // meters
    double toRadians(double degree) => degree * (Math.pi / 180);
    final lat1 = toRadians(a.latitude);
    final lat2 = toRadians(b.latitude);
    final dLat = toRadians(b.latitude - a.latitude);
    final dLng = toRadians(b.longitude - a.longitude);
    final haversine = 0.5 -
        0.5 * Math.cos(dLat) +
        Math.cos(lat1) * Math.cos(lat2) * (1 - Math.cos(dLng));
    return 2 * earthRadius * Math.asin(Math.sqrt(haversine));
  }
}