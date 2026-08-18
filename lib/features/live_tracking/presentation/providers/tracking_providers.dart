import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitcoin/core/integration/integration_providers.dart';
import 'package:fitcoin/features/live_tracking/data/repositories/tracking_repository_impl.dart';
import 'package:fitcoin/features/live_tracking/data/datasources/location_data_source.dart';
import 'package:fitcoin/features/live_tracking/data/datasources/directions_data_source.dart';
import 'package:fitcoin/features/live_tracking/data/datasources/tracking_remote_source.dart';
import 'package:fitcoin/features/live_tracking/domain/repositories/tracking_repository.dart';
import 'package:fitcoin/features/live_tracking/domain/usecases/get_current_location.dart';
import 'package:fitcoin/features/live_tracking/domain/usecases/get_directions.dart';
import 'package:fitcoin/features/live_tracking/domain/usecases/start_tracking.dart';
import 'package:fitcoin/features/live_tracking/domain/usecases/stop_tracking.dart';
import 'package:fitcoin/features/live_tracking/domain/usecases/save_tracking_session.dart';
import 'package:fitcoin/features/live_tracking/presentation/controllers/tracking_controller.dart';
import 'package:fitcoin/features/live_tracking/presentation/states/tracking_states.dart';

final locationDataSourceProvider = Provider<LocationDataSource>((ref) => LocationDataSource());
final directionsDataSourceProvider = Provider<DirectionsDataSource>((ref) => DirectionsDataSource());
final trackingRemoteSourceProvider = Provider<TrackingRemoteSource>((ref) => TrackingRemoteSource());

final trackingRepositoryProvider = Provider<TrackingRepository>((ref) {
  return TrackingRepositoryImpl(
    locationDataSource: ref.watch(locationDataSourceProvider),
    directionsDataSource: ref.watch(directionsDataSourceProvider),
    remoteSource: ref.watch(trackingRemoteSourceProvider),
  );
});

final getCurrentLocationProvider = Provider<GetCurrentLocation>(
      (ref) => GetCurrentLocation(ref.watch(trackingRepositoryProvider)),
);
final getDirectionsProvider = Provider<GetDirections>(
      (ref) => GetDirections(ref.watch(trackingRepositoryProvider)),
);
final startTrackingProvider = Provider<StartTracking>(
      (ref) => StartTracking(ref.watch(trackingRepositoryProvider)),
);
final stopTrackingProvider = Provider<StopTracking>(
      (ref) => StopTracking(ref.watch(trackingRepositoryProvider)),
);
final saveTrackingSessionProvider = Provider<SaveTrackingSession>(
      (ref) => SaveTrackingSession(ref.watch(trackingRepositoryProvider)),
);

final trackingControllerProvider =
StateNotifierProvider<TrackingController, TrackingState>((ref) {
  final integration = ref.watch(stepTrackingIntegrationProvider);
  return TrackingController(
    getCurrentLocation: ref.watch(getCurrentLocationProvider),
    getDirections: ref.watch(getDirectionsProvider),
    startTracking: ref.watch(startTrackingProvider),
    stopTracking: ref.watch(stopTrackingProvider),
    saveTrackingSession: ref.watch(saveTrackingSessionProvider),
    integration: integration,
  );
});