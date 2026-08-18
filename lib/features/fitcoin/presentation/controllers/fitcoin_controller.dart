import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitcoin/features/fitcoin/domain/entities/fitcoin_balance.dart';
import 'package:fitcoin/features/fitcoin/domain/usecases/get_fitcoin_balance.dart';
import 'package:fitcoin/features/fitcoin/domain/usecases/convert_steps_to_fitcoins.dart';
import 'package:fitcoin/features/fitcoin/presentation/states/fitcoin_states.dart';

class FitcoinController extends StateNotifier<FitcoinState> {
  final GetFitcoinBalance _getFitcoinBalance;
  final ConvertStepsToFitcoins _convertStepsToFitcoins;

  FitcoinBalance? _lastBalance;

  FitcoinController({
    required GetFitcoinBalance getFitcoinBalance,
    required ConvertStepsToFitcoins convertStepsToFitcoins,
  })  : _getFitcoinBalance = getFitcoinBalance,
        _convertStepsToFitcoins = convertStepsToFitcoins,
        super(FitcoinInitial());

  Future<void> loadBalance() async {
    state = FitcoinLoading(balance: _lastBalance);
    final result = await _getFitcoinBalance();
    result.fold(
          (failure) => state = FitcoinError(failure.message, balance: _lastBalance),
          (balance) {
        _lastBalance = balance;
        state = FitcoinLoaded(balance);
      },
    );
  }

  Future<void> convertSteps(int stepsToConvert) async {
    state = FitcoinConverting(balance: _lastBalance);
    final result = await _convertStepsToFitcoins(stepsToConvert);
    result.fold(
          (failure) => state = FitcoinError(failure.message, balance: _lastBalance),
          (convertResult) {
        // Update last balance with new values from conversion result
        _lastBalance = FitcoinBalance(
          fitcoinBalance: convertResult.fitcoinBalance,
          todayAvailableSteps: convertResult.remainingSteps,
          conversionRate: convertResult.conversionRate,
        );
        state = FitcoinSuccess(convertResult, balance: _lastBalance);
      },
    );
  }
}