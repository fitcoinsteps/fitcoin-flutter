import 'package:dartz/dartz.dart';
import 'package:fitcoin/core/error/failures.dart';
import 'package:fitcoin/features/live_tracking/domain/entities/location_point.dart';
import 'package:fitcoin/features/live_tracking/domain/entities/route.dart';
import 'package:fitcoin/features/live_tracking/domain/entities/tracking_session.dart';

abstract class TrackingRepository {
  Future<Either<Failure, LocationPoint>> getCurrentLocation();
  Stream<LocationPoint> getLocationStream();
  Future<Either<Failure, RouteInfo>> getDirections({
    required LocationPoint origin,
    required LocationPoint destination,
  });
  Future<Either<Failure, void>> saveTrackingSession(TrackingSession session);
  Stream<TrackingSession> startTracking(LocationPoint start);
  Future<Either<Failure, TrackingSession>> stopTracking();
}