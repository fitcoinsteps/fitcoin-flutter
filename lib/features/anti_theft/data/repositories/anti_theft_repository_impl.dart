import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:fitcoin/core/error/failures.dart';
import 'package:fitcoin/features/anti_theft/data/models/theft_alert.dart';
import 'package:fitcoin/features/anti_theft/data/datasources/anti_theft_remote_source.dart';
import 'package:fitcoin/features/anti_theft/data/datasources/alarm_service.dart';
import 'package:fitcoin/features/anti_theft/data/datasources/camera_service.dart';
import 'package:fitcoin/features/anti_theft/data/datasources/motion_detector_service.dart';
import 'package:fitcoin/features/anti_theft/domain/entities/theft_alert.dart';
import 'package:fitcoin/features/anti_theft/domain/repositories/anti_theft_repository.dart';

class AntiTheftRepositoryImpl implements AntiTheftRepository {
  final MotionDetectorService motionDetectorService;
  final AlarmService alarmService;
  final CameraService cameraService;
  final AntiTheftRemoteSource remoteSource;

  bool _isArmed = false;

  AntiTheftRepositoryImpl({
    required this.motionDetectorService,
    required this.alarmService,
    required this.cameraService,
    required this.remoteSource,
  });

  @override
  Stream<bool> get motionStream => motionDetectorService.motionStream;

  @override
  Future<Either<Failure, void>> arm() async {
    _isArmed = true;
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> disarm() async {
    _isArmed = false;
    await alarmService.stopAlarm();
    return const Right(null);
  }

  @override
  Future<Either<Failure, TheftAlert>> triggerAlert(TheftAlert alert) async {
    try {
      // Play alarm
      await alarmService.startAlarm();

      // Capture photo
      String? photoPath;
      try {
        await cameraService.initialize();
        photoPath = await cameraService.capturePhoto();
      } catch (_) {
        // ignore camera errors
      }

      // Send to backend
      final model = TheftAlertModel(
        userId: alert.userId,
        latitude: alert.latitude,
        longitude: alert.longitude,
        photoPath: photoPath,
        timestamp: alert.timestamp,
      );
      await remoteSource.sendTheftAlert(model);

      return Right(alert);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}