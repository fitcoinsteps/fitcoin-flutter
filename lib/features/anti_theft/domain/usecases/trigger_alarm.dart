import 'package:dartz/dartz.dart';
import 'package:fitcoin/core/error/failures.dart';
import 'package:fitcoin/features/anti_theft/domain/entities/theft_alert.dart';
import 'package:fitcoin/features/anti_theft/domain/repositories/anti_theft_repository.dart';

class TriggerAlarm {
  final AntiTheftRepository repository;
  TriggerAlarm(this.repository);

  Future<Either<Failure, TheftAlert>> call(TheftAlert alert) =>
      repository.triggerAlert(alert);
}