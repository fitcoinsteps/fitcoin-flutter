import 'package:fitcoin/features/live_tracking/domain/entities/route.dart';
import 'package:fitcoin/features/live_tracking/domain/entities/tracking_session.dart';

sealed class TrackingState {}

class TrackingInitial extends TrackingState {}

class TrackingLoading extends TrackingState {}

class TrackingActive extends TrackingState {
  final TrackingSession session;
  final RouteInfo? route;
  TrackingActive({required this.session, this.route});
}

class TrackingStopped extends TrackingState {
  final TrackingSession session;
  TrackingStopped({required this.session});
}

class TrackingError extends TrackingState {
  final String message;
  TrackingError(this.message);
}