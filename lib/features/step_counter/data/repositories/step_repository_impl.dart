import 'dart:async';
import 'dart:math' as Math;
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
      final local = await localSource.getTodaySteps();
      if (local != null) {
        return Right(local);
      } else {
        try {
          final remote = await remoteSource.getTodaySteps();
          await localSource.saveTodaySteps(remote.steps, goal: remote.goal);
          return Right(remote);
        } catch (_) {
          final defaultData = StepDataModel(
            steps: 0,
            goal: 10000,
            date: DateTime.now(),
          );
          return Right(defaultData);
        }
      }
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