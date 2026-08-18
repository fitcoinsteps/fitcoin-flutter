import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';

class MotionDetectorService {
  Stream<bool> get motionStream {
    return accelerometerEventStream().map((event) {
      final magnitude = event.x * event.x + event.y * event.y + event.z * event.z;
      return magnitude > 20; // threshold, adjust as needed
    });
  }
}