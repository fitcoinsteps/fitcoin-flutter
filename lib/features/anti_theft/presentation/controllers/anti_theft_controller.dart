import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitcoin/features/anti_theft/domain/entities/theft_alert.dart';
import 'package:fitcoin/features/anti_theft/domain/usecases/arm_anti_theft.dart';
import 'package:fitcoin/features/anti_theft/domain/usecases/disarm_anti_theft.dart';
import 'package:fitcoin/features/anti_theft/domain/usecases/trigger_alarm.dart';
import 'package:fitcoin/features/anti_theft/presentation/states/anti_theft_states.dart';

class AntiTheftController extends StateNotifier<AntiTheftState> {
  final ArmAntiTheft _armAntiTheft;
  final DisarmAntiTheft _disarmAntiTheft;
  final TriggerAlarm _triggerAlarm;
  final Stream<bool> motionStream;

  StreamSubscription<bool>? _motionSub;

  AntiTheftController({
    required ArmAntiTheft armAntiTheft,
    required DisarmAntiTheft disarmAntiTheft,
    required TriggerAlarm triggerAlarm,
    required this.motionStream,
  })  : _armAntiTheft = armAntiTheft,
        _disarmAntiTheft = disarmAntiTheft,
        _triggerAlarm = triggerAlarm,
        super(AntiTheftInitial());

  void arm() {
    _armAntiTheft();
    state = AntiTheftArmed();
    _startMonitoring();
  }

  void disarm() {
    _disarmAntiTheft();
    _motionSub?.cancel();
    state = AntiTheftDisarmed();
  }

  void _startMonitoring() {
    _motionSub?.cancel();
    _motionSub = motionStream.listen((isMoving) {
      if (isMoving) {
        _handleMotionDetected();
      }
    });
  }

  Future<void> _handleMotionDetected() async {
    // Simulate location and trigger alert
    final alert = TheftAlert(
      userId: 'current_user_id', // should come from auth
      latitude: 0.0, // get from location service
      longitude: 0.0,
      timestamp: DateTime.now(),
    );
    final result = await _triggerAlarm(alert);
    result.fold(
          (failure) => state = AntiTheftTriggered('Alarm failed: ${failure.message}'),
          (_) => state = AntiTheftTriggered('Alert sent and alarm sounding!'),
    );
  }

  @override
  void dispose() {
    _motionSub?.cancel();
    super.dispose();
  }
}