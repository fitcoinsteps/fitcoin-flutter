import 'dart:async';
import 'dart:math' as Math;
import 'package:sensors_plus/sensors_plus.dart';

class StepSensorService {
  // Tuning parameters – adjust these to change sensitivity
  static const double gravity = 9.81;
  static const double threshold = 1.2;       // peak detection threshold
  static const Duration minStepInterval = Duration(milliseconds: 250);

  Stream<int> startStepStream() {
    return _detectStepsFromAccelerometer();
  }

  Stream<int> _detectStepsFromAccelerometer() {
    final controller = StreamController<int>();

    double lastMagnitude = gravity;
    bool isAboveThreshold = false;
    int stepCount = 0;
    DateTime lastStepTime = DateTime.now();

    final subscription = accelerometerEventStream().listen((event) {
      // Compute magnitude
      final magnitude = Math.sqrt(
        event.x * event.x + event.y * event.y + event.z * event.z,
      );

      // Low-pass filter (smooth)
      final filteredMagnitude = 0.8 * lastMagnitude + 0.2 * magnitude;
      lastMagnitude = filteredMagnitude;

      // Detect crossing above threshold
      if (!isAboveThreshold && filteredMagnitude > gravity + threshold) {
        isAboveThreshold = true;
      }

      // Detect crossing below threshold after being above
      if (isAboveThreshold && filteredMagnitude < gravity + threshold) {
        isAboveThreshold = false;

        // Ensure minimum time between steps to avoid double counting
        final now = DateTime.now();
        if (now.difference(lastStepTime) >= minStepInterval) {
          stepCount++;
          lastStepTime = now;
          controller.add(stepCount);
        }
      }
    });

    controller.onCancel = () {
      subscription.cancel();
    };

    return controller.stream;
  }
}