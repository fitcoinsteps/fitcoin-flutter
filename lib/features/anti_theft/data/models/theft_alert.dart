class TheftAlertModel {
  final String userId;
  final double latitude;
  final double longitude;
  final String? photoPath;
  final DateTime timestamp;

  TheftAlertModel({
    required this.userId,
    required this.latitude,
    required this.longitude,
    this.photoPath,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'latitude': latitude,
    'longitude': longitude,
    'photo_path': photoPath,
    'timestamp': timestamp.toIso8601String(),
  };
}