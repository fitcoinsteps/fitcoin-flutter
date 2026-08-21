import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:fitcoin/core/error/failures.dart';
import 'package:fitcoin/features/step_counter/domain/entities/step_data.dart';
import 'package:fitcoin/features/step_counter/domain/repositories/step_repository.dart';
import 'package:fitcoin/features/step_counter/data/models/step_data_model.dart';
import 'package:fitcoin/features/step_counter/data/datasources/step_local_source.dart';
import 'package:fitcoin/features/step_counter/data/datasources/step_remote_source.dart';
import 'package:fitcoin/features/step_counter/data/datasources/step_sensor_service.dart';

class StepRepositoryImpl implements StepRepository {
  final StepLocalSource localSource;
  final StepRemoteSource remoteSource;
  final StepSensorService sensorService;

  int _lastKnownSteps = 0;
  DateTime? _lastAcceptedStepTime;

  StepRepositoryImpl({
    required this.localSource,
    required this.remoteSource,
    required this.sensorService,
  });

  @override
  Future<Either<Failure, StepData>> getTodaySteps() async {
    try {
      // 1. Load local steps first (these may be unsynced)
      final local = await localSource.getTodaySteps();
      print('🔄 Local steps: ${local?.steps}');

      // 2. Try to fetch remote steps (may fail)
      StepData? remote;
      try {
        remote = await remoteSource.getTodaySteps();
        print('✅ Remote steps: ${remote?.steps}');
      } catch (e) {
        print('❌ Remote fetch failed, using local only');
      }

      // 3. Determine final values (take max)
      int finalSteps = 0;
      int goal = 10000;
      DateTime date = DateTime.now();

      if (local != null) {
        finalSteps = local.steps;
        goal = local.goal;
        date = local.date;
      }
      if (remote != null && remote.steps > finalSteps) {
        finalSteps = remote.steps;
        goal = remote.goal;
        date = remote.date;
      }

      // 4. If local steps > remote, push local to backend
      if (local != null && (remote == null || local.steps > remote.steps)) {
        print('🔄 Local steps greater than remote, syncing local to remote...');
        await remoteSource.syncSteps(local);
      }

      // 5. Save merged result locally
      final merged = StepDataModel(
        steps: finalSteps,
        goal: goal,
        date: DateTime.now(),
      );
      await localSource.saveTodaySteps(merged.steps, goal: merged.goal);

      return Right(merged);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveDailySteps(StepData stepData) async {
    try {
      await localSource.saveTodaySteps(stepData.steps, goal: stepData.goal);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, StepData>> syncSteps(StepData stepData) async {
    try {
      final model = StepDataModel(
        steps: stepData.steps,
        goal: stepData.goal,
        date: stepData.date,
      );
      final synced = await remoteSource.syncSteps(model);
      return Right(synced);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateGoal(int goal) async {
    try {
      await remoteSource.updateGoal(goal);
      final local = await localSource.getTodaySteps();
      if (local != null) {
        await localSource.saveTodaySteps(local.steps, goal: goal);
      }
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Stream<int> startStepStream() {
    _lastKnownSteps = 0;
    _lastAcceptedStepTime = null;

    return sensorService.startStepStream().map((totalSteps) {
      if (_lastKnownSteps == 0) {
        _lastKnownSteps = totalSteps;
        return 0;
      }
      final delta = totalSteps - _lastKnownSteps;
      _lastKnownSteps = totalSteps;
      if (delta <= 0) return 0;

      final now = DateTime.now();
      if (_lastAcceptedStepTime == null ||
          now.difference(_lastAcceptedStepTime!) >=
              const Duration(milliseconds: 400)) {
        _lastAcceptedStepTime = now;
        return delta;
      }
      return 0;
    }).where((delta) => delta > 0);
  }
}