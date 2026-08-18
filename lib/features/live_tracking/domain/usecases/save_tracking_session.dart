import 'package:dartz/dartz.dart';
import 'package:fitcoin/core/error/failures.dart';
import 'package:fitcoin/features/live_tracking/domain/entities/tracking_session.dart';
import 'package:fitcoin/features/live_tracking/domain/repositories/tracking_repository.dart';

class SaveTrackingSession {
  final TrackingRepository repository;
  SaveTrackingSession(this.repository);

  Future<Either<Failure, void>> call(TrackingSession session) =>
      repository.saveTrackingSession(session);
}