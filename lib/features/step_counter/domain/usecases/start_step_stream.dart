import 'package:fitcoin/features/step_counter/domain/repositories/step_repository.dart';

class StartStepStream {
  final StepRepository repository;
  StartStepStream(this.repository);

  Stream<int> call() => repository.startStepStream();
}