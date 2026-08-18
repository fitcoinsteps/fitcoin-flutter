import 'package:fitcoin/features/step_counter/domain/entities/step_data.dart';

sealed class StepState {}

class StepInitial extends StepState {}

class StepLoading extends StepState {}

class StepLoaded extends StepState {
  final StepData stepData;
  final bool isSyncing;
  StepLoaded({required this.stepData, this.isSyncing = false});
}

class StepError extends StepState {
  final String message;
  StepError(this.message);
}