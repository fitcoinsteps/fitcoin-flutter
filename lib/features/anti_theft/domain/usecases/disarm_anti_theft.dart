import 'package:dartz/dartz.dart';
import 'package:fitcoin/core/error/failures.dart';
import 'package:fitcoin/features/anti_theft/domain/repositories/anti_theft_repository.dart';

class DisarmAntiTheft {
  final AntiTheftRepository repository;
  DisarmAntiTheft(this.repository);

  Future<Either<Failure, void>> call() => repository.disarm();
}