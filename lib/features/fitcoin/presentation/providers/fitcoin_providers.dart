import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitcoin/features/fitcoin/data/datasources/fitcoin_remote_source.dart';
import 'package:fitcoin/features/fitcoin/data/repositories/fitcoin_repository_impl.dart';
import 'package:fitcoin/features/fitcoin/domain/repositories/fitcoin_repository.dart';
import 'package:fitcoin/features/fitcoin/domain/usecases/get_fitcoin_balance.dart';
import 'package:fitcoin/features/fitcoin/domain/usecases/convert_steps_to_fitcoins.dart';
import 'package:fitcoin/features/fitcoin/presentation/controllers/fitcoin_controller.dart';
import 'package:fitcoin/features/fitcoin/presentation/states/fitcoin_states.dart';

final fitcoinRemoteSourceProvider = Provider<FitcoinRemoteSource>((ref) {
  return FitcoinRemoteSource();
});

final fitcoinRepositoryProvider = Provider<FitcoinRepository>((ref) {
  return FitcoinRepositoryImpl(
    remoteSource: ref.watch(fitcoinRemoteSourceProvider),
  );
});

final getFitcoinBalanceProvider = Provider<GetFitcoinBalance>((ref) {
  return GetFitcoinBalance(ref.watch(fitcoinRepositoryProvider));
});

final convertStepsToFitcoinsProvider = Provider<ConvertStepsToFitcoins>((ref) {
  return ConvertStepsToFitcoins(ref.watch(fitcoinRepositoryProvider));
});

final fitcoinControllerProvider =
StateNotifierProvider<FitcoinController, FitcoinState>((ref) {
  return FitcoinController(
    getFitcoinBalance: ref.watch(getFitcoinBalanceProvider),
    convertStepsToFitcoins: ref.watch(convertStepsToFitcoinsProvider),
  );
});