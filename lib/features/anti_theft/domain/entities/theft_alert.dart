class TheftAlert {
  final String userId;
  final double latitude;
  final double longitude;
  final String? photoPath;
  final DateTime timestamp;

  TheftAlert({
    required this.userId,
    required this.latitude,
    required this.longitude,
    this.photoPath,
    required this.timestamp,
  });
}