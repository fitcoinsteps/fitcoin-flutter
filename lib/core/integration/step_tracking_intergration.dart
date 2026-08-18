import 'package:dartz/dartz.dart';
import 'package:fitcoin/features/step_counter/domain/entities/step_data.dart';
import 'package:fitcoin/features/step_counter/domain/repositories/step_repository.dart';
import 'package:fitcoin/features/live_tracking/domain/entities/tracking_session.dart';

class StepTrackingIntegration {
  final StepRepository stepRepository;

  StepTrackingIntegration({required this.stepRepository});

  /// After tracking ends, estimate steps from distance and save.
  Future<void> syncTrackingToSteps(TrackingSession session) async {
    double distanceKm = _calculateDistanceKm(session);
    int estimatedSteps = (distanceKm * 1300).round();

    if (estimatedSteps <= 0) return;

    final todayStepsResult = await stepRepository.getTodaySteps();
    int currentSteps = 0;
    int goal = 10000;
    todayStepsResult.fold(
          (failure) => print('Error fetching steps: ${failure.message}'),
          (stepData) {
        currentSteps = stepData.steps;
        goal = stepData.goal;
      },
    );

    final newSteps = currentSteps + estimatedSteps;
    final updatedStepData = StepData(
      steps: newSteps,
      goal: goal,
      date: DateTime.now(),
    );

    await stepRepository.saveDailySteps(updatedStepData);
    await stepRepository.syncSteps(updatedStepData);
  }

  double _calculateDistanceKm(TrackingSession session) {
    if (session.route != null) {
      return session.route!.distanceMeters / 1000.0;
    }
    return 0.0;
  }
}