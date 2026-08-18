import 'package:dartz/dartz.dart';
import 'package:fitcoin/core/error/failures.dart';
import 'package:fitcoin/features/live_tracking/domain/entities/location_point.dart';
import 'package:fitcoin/features/live_tracking/domain/entities/route.dart';
import 'package:fitcoin/features/live_tracking/domain/repositories/tracking_repository.dart';

class GetDirections {
  final TrackingRepository repository;
  GetDirections(this.repository);

  Future<Either<Failure, RouteInfo>> call(LocationPoint origin, LocationPoint destination) =>
      repository.getDirections(origin: origin, destination: destination);
}