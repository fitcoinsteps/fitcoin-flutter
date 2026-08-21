import 'dart:async';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fitcoin/features/step_counter/domain/entities/step_data.dart';
import 'package:fitcoin/features/step_counter/domain/usecases/get_today_steps.dart';
import 'package:fitcoin/features/step_counter/domain/usecases/save_daily_steps.dart';
import 'package:fitcoin/features/step_counter/domain/usecases/sync_steps.dart';
import 'package:fitcoin/features/step_counter/domain/usecases/start_step_stream.dart';
import 'package:fitcoin/features/step_counter/domain/usecases/update_step_goal.dart';
import 'package:fitcoin/features/step_counter/presentation/states/step_states.dart';

class StepController extends StateNotifier<StepState> {
  final GetTodaySteps _getTodaySteps;
  final SaveDailySteps _saveDailySteps;
  final SyncSteps _syncSteps;
  final StartStepStream _startStepStream;
  final UpdateStepGoal _updateStepGoal;
  final Future<void> Function()? _onStepsSynced;   // ✅ callback

  StreamSubscription<int>? _stepSubscription;
  Timer? _autoSyncTimer;

  int _currentSteps = 0;
  int _goal = 10000;
  bool _isSyncing = false;   // ✅ Prevent overlapping sync requests

  StepController({
    required GetTodaySteps getTodaySteps,
    required SaveDailySteps saveDailySteps,
    required SyncSteps syncSteps,
    required StartStepStream startStepStream,
    required UpdateStepGoal updateStepGoal,
    Future<void> Function()? onStepsSynced,   // ✅ optional
  })  : _getTodaySteps = getTodaySteps,
        _saveDailySteps = saveDailySteps,
        _syncSteps = syncSteps,
        _startStepStream = startStepStream,
        _updateStepGoal = updateStepGoal,
        _onStepsSynced = onStepsSynced,
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
        // ✅ Force sync with backend after loading
        syncNow();
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
            // ✅ Immediately push to backend
            syncNow();
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
    if (_isSyncing) return;                     // ✅ Guard: skip if already syncing
    if (state is! StepLoaded) return;

    _isSyncing = true;
    final currentState = state as StepLoaded;
    state = StepLoaded(stepData: currentState.stepData, isSyncing: true);

    final result = await _syncSteps(
      StepData(steps: _currentSteps, goal: _goal, date: DateTime.now()),
    );

    _isSyncing = false;

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
        // ✅ Trigger challenge refresh after successful step sync
        _onStepsSynced?.call();
      },
    );
  }

  Future<void> updateGoal(int goal) async {
    final result = await _updateStepGoal(goal);
    result.fold(
          (failure) => state = StepError(failure.message),
          (_) {
        _goal = goal;
        _updateState();
        _saveDailySteps(StepData(
          steps: _currentSteps,
          goal: _goal,
          date: DateTime.now(),
        ));
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