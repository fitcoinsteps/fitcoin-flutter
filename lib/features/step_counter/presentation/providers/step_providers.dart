import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fitcoin/features/step_counter/data/datasources/step_local_source.dart';
import 'package:fitcoin/features/step_counter/data/datasources/step_remote_source.dart';
import 'package:fitcoin/features/step_counter/data/datasources/step_sensor_service.dart' show StepSensorService;
import 'package:fitcoin/features/step_counter/data/repositories/step_repository_impl.dart' show StepRepositoryImpl;
import 'package:fitcoin/features/step_counter/domain/repositories/step_repository.dart' show StepRepository;
import 'package:fitcoin/features/step_counter/domain/usecases/get_today_steps.dart' show GetTodaySteps;
import 'package:fitcoin/features/step_counter/domain/usecases/save_daily_steps.dart' show SaveDailySteps;
import 'package:fitcoin/features/step_counter/domain/usecases/sync_steps.dart' show SyncSteps;
import 'package:fitcoin/features/step_counter/domain/usecases/start_step_stream.dart' show StartStepStream;
import 'package:fitcoin/features/step_counter/domain/usecases/update_step_goal.dart' show UpdateStepGoal;
import 'package:fitcoin/features/step_counter/presentation/controllers/step_controller.dart' show StepController;
import 'package:fitcoin/features/step_counter/presentation/states/step_states.dart' show StepState;
// ✅ Import challenge provider to call its refresh
import 'package:fitcoin/features/challenges/presentation/providers/challenge_providers.dart';
// ✅ Import fitcoin provider to refresh balance
import 'package:fitcoin/features/fitcoin/presentation/providers/fitcoin_providers.dart';

// Data sources
final stepLocalSourceProvider =
Provider<StepLocalSource>((ref) => StepLocalSource());
final stepRemoteSourceProvider =
Provider<StepRemoteSource>((ref) => StepRemoteSource());
final stepSensorServiceProvider =
Provider<StepSensorService>((ref) => StepSensorService());

// Repository
final stepRepositoryProvider = Provider<StepRepository>((ref) {
  return StepRepositoryImpl(
    localSource: ref.watch(stepLocalSourceProvider),
    remoteSource: ref.watch(stepRemoteSourceProvider),
    sensorService: ref.watch(stepSensorServiceProvider),
  );
});

// Use cases
final getTodayStepsProvider = Provider<GetTodaySteps>(
      (ref) => GetTodaySteps(ref.watch(stepRepositoryProvider)),
);
final saveDailyStepsProvider = Provider<SaveDailySteps>(
      (ref) => SaveDailySteps(ref.watch(stepRepositoryProvider)),
);
final syncStepsProvider = Provider<SyncSteps>(
      (ref) => SyncSteps(ref.watch(stepRepositoryProvider)),
);
final startStepStreamProvider = Provider<StartStepStream>(
      (ref) => StartStepStream(ref.watch(stepRepositoryProvider)),
);
final updateStepGoalProvider = Provider<UpdateStepGoal>(
      (ref) => UpdateStepGoal(ref.watch(stepRepositoryProvider)),
);

// Controller
final stepControllerProvider =
StateNotifierProvider<StepController, StepState>((ref) {
  return StepController(
    getTodaySteps: ref.watch(getTodayStepsProvider),
    saveDailySteps: ref.watch(saveDailyStepsProvider),
    syncSteps: ref.watch(syncStepsProvider),
    startStepStream: ref.watch(startStepStreamProvider),
    updateStepGoal: ref.watch(updateStepGoalProvider),
    // ✅ Refresh challenges AND fitcoin balance after successful step sync
    onStepsSynced: () async {
      await ref.read(challengeControllerProvider.notifier).loadChallenges();
      await ref.read(fitcoinControllerProvider.notifier).loadBalance();
    },
  );
});