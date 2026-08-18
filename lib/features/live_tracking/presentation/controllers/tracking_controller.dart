import 'dart:async';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fitcoin/core/integration/step_tracking_intergration.dart';
import 'package:fitcoin/features/live_tracking/domain/entities/location_point.dart';
import 'package:fitcoin/features/live_tracking/domain/entities/route.dart';
import 'package:fitcoin/features/live_tracking/domain/entities/tracking_session.dart';
import 'package:fitcoin/features/live_tracking/domain/usecases/get_current_location.dart';
import 'package:fitcoin/features/live_tracking/domain/usecases/get_directions.dart';
import 'package:fitcoin/features/live_tracking/domain/usecases/start_tracking.dart';
import 'package:fitcoin/features/live_tracking/domain/usecases/stop_tracking.dart';
import 'package:fitcoin/features/live_tracking/domain/usecases/save_tracking_session.dart';
import 'package:fitcoin/features/live_tracking/presentation/states/tracking_states.dart';

class TrackingController extends StateNotifier<TrackingState> {
  final GetCurrentLocation _getCurrentLocation;
  final GetDirections _getDirections;
  final StartTracking _startTracking;
  final StopTracking _stopTracking;
  final SaveTrackingSession _saveTrackingSession;
  final StepTrackingIntegration _integration;

  StreamSubscription<TrackingSession>? _trackingSub;
  LocationPoint? _currentLocation;
  RouteInfo? _route;

  TrackingController({
    required GetCurrentLocation getCurrentLocation,
    required GetDirections getDirections,
    required StartTracking startTracking,
    required StopTracking stopTracking,
    required SaveTrackingSession saveTrackingSession,
    required StepTrackingIntegration integration,
  })  : _getCurrentLocation = getCurrentLocation,
        _getDirections = getDirections,
        _startTracking = startTracking,
        _stopTracking = stopTracking,
        _saveTrackingSession = saveTrackingSession,
        _integration = integration,
        super(TrackingInitial());

  Future<void> initialize() async {
    state = TrackingLoading();

    // Request location permission
    var status = await Permission.locationWhenInUse.status;
    if (!status.isGranted) {
      status = await Permission.locationWhenInUse.request();
    }
    if (!status.isGranted) {
      state = TrackingError('Location permission denied');
      return;
    }

    final locResult = await _getCurrentLocation();
    locResult.fold(
          (failure) => state = TrackingError(failure.message),
          (location) {
        _currentLocation = location;
        state = TrackingInitial();
      },
    );
  }

  Future<void> fetchRoute(LocationPoint destination) async {
    if (_currentLocation == null) return;
    final routeResult = await _getDirections(_currentLocation!, destination);
    routeResult.fold(
          (failure) => state = TrackingError(failure.message),
          (route) {
        _route = route;
        if (state is TrackingActive) {
          state = TrackingActive(
            session: (state as TrackingActive).session,
            route: route,
          );
        } else {
          // Maybe show route on map but not tracking yet
          state = TrackingInitial(); // placeholder; you can handle separately
        }
      },
    );
  }

  Future<void> startTracking() async {
    if (_currentLocation == null) return;
    _trackingSub?.cancel();
    _trackingSub = _startTracking(_currentLocation!).listen(
          (session) {
        state = TrackingActive(session: session, route: _route);
      },
      onError: (e) => state = TrackingError('Tracking error: $e'),
    );
  }

  Future<void> stopTracking() async {
    final result = await _stopTracking();
    result.fold(
          (failure) => state = TrackingError(failure.message),
          (session) async {
        _trackingSub?.cancel();
        state = TrackingStopped(session: session);

        // 🔗 Update step counter with estimated steps from distance
        await _integration.syncTrackingToSteps(session);

        // Save to backend (optional)
        final saveResult = await _saveTrackingSession(session);
        saveResult.fold(
              (failure) => print('Failed to save session: ${failure.message}'),
              (_) => print('Session saved'),
        );
      },
    );
  }

  @override
  void dispose() {
    _trackingSub?.cancel();
    super.dispose();
  }
}