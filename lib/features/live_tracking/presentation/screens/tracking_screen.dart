import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fitcoin/features/live_tracking/domain/entities/location_point.dart';
import 'package:fitcoin/features/live_tracking/presentation/providers/tracking_providers.dart';
import 'package:fitcoin/features/live_tracking/presentation/states/tracking_states.dart';
import 'package:fitcoin/features/live_tracking/presentation/widgets/destination_search_sheet.dart';
import 'package:fitcoin/features/live_tracking/presentation/widgets/tracking_stats_card.dart';

class TrackingScreen extends ConsumerStatefulWidget {
  const TrackingScreen({super.key});

  @override
  ConsumerState<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends ConsumerState<TrackingScreen> {
  GoogleMapController? _mapController;
  LocationPoint? _destination;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(trackingControllerProvider.notifier).initialize();
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  Future<void> _pickDestination() async {
    final destination = await showModalBottomSheet<LocationPoint>(
      context: context,
      builder: (context) => const DestinationSearchSheet(),
    );
    if (destination != null) {
      setState(() {
        _destination = destination;
        _markers = {
          Marker(
            markerId: const MarkerId('destination'),
            position: LatLng(destination.latitude, destination.longitude),
            infoWindow: const InfoWindow(title: 'Destination'),
          ),
        };
      });
      ref.read(trackingControllerProvider.notifier).fetchRoute(destination);
    }
  }

  void _toggleTracking() {
    final state = ref.read(trackingControllerProvider);
    if (state is TrackingActive) {
      ref.read(trackingControllerProvider.notifier).stopTracking();
    } else {
      ref.read(trackingControllerProvider.notifier).startTracking();
    }
  }

  @override
  Widget build(BuildContext context) {
    final trackingState = ref.watch(trackingControllerProvider);

    // Determine initial map position
    LatLng initialPosition = const LatLng(0, 0);
    if (trackingState is TrackingActive) {
      final session = trackingState.session;
      initialPosition = LatLng(
        session.startLocation.latitude,
        session.startLocation.longitude,
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Live Tracking')),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: initialPosition,
              zoom: 15,
            ),
            markers: _markers,
            polylines: _polylines,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: ElevatedButton.icon(
              onPressed: _pickDestination,
              icon: const Icon(Icons.search),
              label: Text(_destination == null ? 'Choose destination' : 'Destination set'),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Column(
              children: [
                if (trackingState is TrackingActive)
                  TrackingStatsCard(session: trackingState.session),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _toggleTracking,
                  child: Text(trackingState is TrackingActive ? 'Stop Tracking' : 'Start Tracking'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}