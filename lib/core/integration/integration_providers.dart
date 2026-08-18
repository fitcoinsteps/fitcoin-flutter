import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitcoin/core/integration/step_tracking_intergration.dart';
import 'package:fitcoin/features/step_counter/presentation/providers/step_providers.dart';

final stepTrackingIntegrationProvider = Provider<StepTrackingIntegration>((ref) {
  final stepRepo = ref.watch(stepRepositoryProvider);
  return StepTrackingIntegration(stepRepository: stepRepo);
});