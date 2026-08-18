import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitcoin/features/anti_theft/data/repositories/anti_theft_repository_impl.dart';
import 'package:fitcoin/features/anti_theft/data/datasources/alarm_service.dart';
import 'package:fitcoin/features/anti_theft/data/datasources/camera_service.dart';
import 'package:fitcoin/features/anti_theft/data/datasources/motion_detector_service.dart';
import 'package:fitcoin/features/anti_theft/data/datasources/anti_theft_remote_source.dart';
import 'package:fitcoin/features/anti_theft/domain/repositories/anti_theft_repository.dart';
import 'package:fitcoin/features/anti_theft/domain/usecases/arm_anti_theft.dart';
import 'package:fitcoin/features/anti_theft/domain/usecases/disarm_anti_theft.dart';
import 'package:fitcoin/features/anti_theft/domain/usecases/trigger_alarm.dart';
import 'package:fitcoin/features/anti_theft/presentation/controllers/anti_theft_controller.dart';
import 'package:fitcoin/features/anti_theft/presentation/states/anti_theft_states.dart';

final motionDetectorServiceProvider =
Provider<MotionDetectorService>((ref) => MotionDetectorService());
final alarmServiceProvider = Provider<AlarmService>((ref) => AlarmService());
final cameraServiceProvider = Provider<CameraService>((ref) => CameraService());
final antiTheftRemoteSourceProvider =
Provider<AntiTheftRemoteSource>((ref) => AntiTheftRemoteSource());

final antiTheftRepositoryProvider = Provider<AntiTheftRepository>((ref) {
  return AntiTheftRepositoryImpl(
    motionDetectorService: ref.watch(motionDetectorServiceProvider),
    alarmService: ref.watch(alarmServiceProvider),
    cameraService: ref.watch(cameraServiceProvider),
    remoteSource: ref.watch(antiTheftRemoteSourceProvider),
  );
});

final armAntiTheftProvider = Provider<ArmAntiTheft>(
        (ref) => ArmAntiTheft(ref.watch(antiTheftRepositoryProvider)));
final disarmAntiTheftProvider = Provider<DisarmAntiTheft>(
        (ref) => DisarmAntiTheft(ref.watch(antiTheftRepositoryProvider)));
final triggerAlarmProvider = Provider<TriggerAlarm>(
        (ref) => TriggerAlarm(ref.watch(antiTheftRepositoryProvider)));

final antiTheftControllerProvider =
StateNotifierProvider<AntiTheftController, AntiTheftState>((ref) {
  final motionStream = ref.watch(antiTheftRepositoryProvider).motionStream;
  return AntiTheftController(
    armAntiTheft: ref.watch(armAntiTheftProvider),
    disarmAntiTheft: ref.watch(disarmAntiTheftProvider),
    triggerAlarm: ref.watch(triggerAlarmProvider),
    motionStream: motionStream,
  );
});