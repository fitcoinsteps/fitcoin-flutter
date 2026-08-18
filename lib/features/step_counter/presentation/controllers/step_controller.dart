import 'dart:async';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fitcoin/features/step_counter/domain/entities/step_data.dart';
import 'package:fitcoin/features/step_counter/domain/usecases/get_today_steps.dart';
import 'package:fitcoin/features/step_counter/domain/usecases/save_daily_steps.dart';
import 'package:fitcoin/features/step_counter/domain/usecases/sync_steps.dart';
import 'package:fitcoin/features/step_counter/domain/usecases/start_step_stream.dart';
import 'package:fitcoin/features/step_counter/presentation/states/step_states.dart';

class StepController extends StateNotifier<StepState> {
  final GetTodaySteps _getTodaySteps;
  final SaveDailySteps _saveDailySteps;
  final SyncSteps _syncSteps;
  final StartStepStream _startStepStream;

  StreamSubscription<int>? _stepSubscription;
  Timer? _autoSyncTimer;

  int _currentSteps = 0;
  int _goal = 10000;

  StepController({
    required GetTodaySteps getTodaySteps,
    required SaveDailySteps saveDailySteps,
    required SyncSteps syncSteps,
    required StartStepStream startStepStream,
  })  : _getTodaySteps = getTodaySteps,
        _saveDailySteps = saveDailySteps,
        _syncSteps = syncSteps,
        _startStepStream = startStepStream,
        super(StepInitial());

  Future<void> init() async {
    state = StepLoading();
    final result = await _getTodaySteps();
    result.fold(
          (failure) => state = StepError(failure.message),
          (stepData) {
        _currentSteps = stepData.steps;
        _goal = stepData.goal;
        state = StepLoaded(stepData: stepData);
      },
    );
    _startAutoSync();
  }

  Future<void> startStepCounting() async {
    if (Platform.isAndroid) {
      var status = await Permission.activityRecognition.status;
      if (!status.isGranted) {
        status = await Permission.activityRecognition.request();
      }
      if (!status.isGranted) {
        state = StepError('Activity recognition permission denied');
        return;
      }
    }

    try {
      await _stepSubscription?.cancel();
      _stepSubscription = _startStepStream().listen(
            (delta) {
          if (delta > 0) {
            _currentSteps += delta;
            _updateState();
            _saveDailySteps(StepData(
              steps: _currentSteps,
              goal: _goal,
              date: DateTime.now(),
            ));
          }
        },
        onError: (error) => state = StepError('Step sensor error: $error'),
      );
    } catch (e) {
      state = StepError('Failed to start step counting: $e');
    }
  }

  Future<void> stopStepCounting() async {
    await _stepSubscription?.cancel();
    _stepSubscription = null;
  }

  void _startAutoSync() {
    _autoSyncTimer = Timer.periodic(const Duration(minutes: 5), (_) {
      syncNow();
    });
  }

  Future<void> syncNow() async {
    if (state is! StepLoaded) return;

    final currentState = state as StepLoaded;
    state = StepLoaded(stepData: currentState.stepData, isSyncing: true);

    final result = await _syncSteps(
      StepData(steps: _currentSteps, goal: _goal, date: DateTime.now()),
    );

    result.fold(
          (failure) {
        state = StepLoaded(
          stepData: StepData(
              steps: _currentSteps, goal: _goal, date: DateTime.now()),
          isSyncing: false,
        );
      },
          (syncedStep) {
        _currentSteps = syncedStep.steps;
        state = StepLoaded(stepData: syncedStep, isSyncing: false);
      },
    );
  }

  void _updateState() {
    state = StepLoaded(
      stepData: StepData(
          steps: _currentSteps, goal: _goal, date: DateTime.now()),
    );
  }

  @override
  void dispose() {
    _stepSubscription?.cancel();
    _autoSyncTimer?.cancel();
    super.dispose();
  }
}