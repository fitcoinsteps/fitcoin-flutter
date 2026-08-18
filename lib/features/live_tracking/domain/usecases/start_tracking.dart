import 'package:fitcoin/features/live_tracking/domain/entities/location_point.dart';
import 'package:fitcoin/features/live_tracking/domain/entities/tracking_session.dart';
import 'package:fitcoin/features/live_tracking/domain/repositories/tracking_repository.dart';

class StartTracking {
  final TrackingRepository repository;
  StartTracking(this.repository);

  Stream<TrackingSession> call(LocationPoint start) => repository.startTracking(start);
}