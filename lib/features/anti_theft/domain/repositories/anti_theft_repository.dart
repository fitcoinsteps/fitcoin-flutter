import 'package:dartz/dartz.dart';
import 'package:fitcoin/core/error/failures.dart';
import 'package:fitcoin/features/anti_theft/domain/entities/theft_alert.dart';

abstract class AntiTheftRepository {
  Future<Either<Failure, void>> arm();
  Future<Either<Failure, void>> disarm();
  Future<Either<Failure, TheftAlert>> triggerAlert(TheftAlert alert);
  Stream<bool> get motionStream;
}