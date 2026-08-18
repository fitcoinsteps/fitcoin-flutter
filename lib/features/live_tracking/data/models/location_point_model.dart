class LocationPointModel {
  final double latitude;
  final double longitude;
  final DateTime timestamp;

  LocationPointModel({
    required this.latitude,
    required this.longitude,
    required this.timestamp,
  });

  factory LocationPointModel.fromJson(Map<String, dynamic> json) =>
      LocationPointModel(
        latitude: json['latitude'],
        longitude: json['longitude'],
        timestamp: DateTime.parse(json['timestamp']),
      );

  Map<String, dynamic> toJson() => {
    'latitude': latitude,
    'longitude': longitude,
    'timestamp': timestamp.toIso8601String(),
  };
}