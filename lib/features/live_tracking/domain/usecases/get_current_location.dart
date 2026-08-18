import 'package:dartz/dartz.dart';
import 'package:fitcoin/core/error/failures.dart';
import 'package:fitcoin/features/live_tracking/domain/entities/location_point.dart';
import 'package:fitcoin/features/live_tracking/domain/repositories/tracking_repository.dart';

class GetCurrentLocation {
  final TrackingRepository repository;
  GetCurrentLocation(this.repository);

  Future<Either<Failure, LocationPoint>> call() => repository.getCurrentLocation();
}