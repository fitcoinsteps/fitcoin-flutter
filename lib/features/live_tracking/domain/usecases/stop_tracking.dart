import 'package:dartz/dartz.dart';
import 'package:fitcoin/core/error/failures.dart';
import 'package:fitcoin/features/live_tracking/domain/entities/tracking_session.dart';
import 'package:fitcoin/features/live_tracking/domain/repositories/tracking_repository.dart';

class StopTracking {
  final TrackingRepository repository;
  StopTracking(this.repository);

  Future<Either<Failure, TrackingSession>> call() => repository.stopTracking();
}