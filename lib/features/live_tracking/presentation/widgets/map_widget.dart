import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWidget extends StatelessWidget {
  final GoogleMapController? Function(GoogleMapController)? onMapCreated;
  final Set<Marker> markers;
  final Set<Polyline> polylines;
  final LatLng initialPosition;

  const MapWidget({
    super.key,
    required this.onMapCreated,
    required this.markers,
    required this.polylines,
    required this.initialPosition,
  });

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: onMapCreated,
      initialCameraPosition: CameraPosition(
        target: initialPosition,
        zoom: 15,
      ),
      markers: markers,
      polylines: polylines,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
    );
  }
}