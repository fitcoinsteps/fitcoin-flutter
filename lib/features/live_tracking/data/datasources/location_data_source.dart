import 'package:geolocator/geolocator.dart';
import 'package:fitcoin/features/live_tracking/domain/entities/location_point.dart';

class LocationDataSource {
  Stream<LocationPoint> getLocationStream() {
    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10, // meters
    );
    return Geolocator.getPositionStream(locationSettings: locationSettings)
        .map((position) => LocationPoint(
      latitude: position.latitude,
      longitude: position.longitude,
      timestamp: position.timestamp ?? DateTime.now(),
    ));
  }

  Future<LocationPoint> getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition();
    return LocationPoint(
      latitude: position.latitude,
      longitude: position.longitude,
      timestamp: position.timestamp ?? DateTime.now(),
    );
  }
}