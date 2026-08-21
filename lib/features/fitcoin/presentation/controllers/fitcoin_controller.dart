import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitcoin/features/fitcoin/domain/entities/fitcoin_balance.dart';
import 'package:fitcoin/features/fitcoin/domain/usecases/get_fitcoin_balance.dart';
import 'package:fitcoin/features/fitcoin/domain/usecases/convert_steps_to_fitcoins.dart';
import 'package:fitcoin/features/fitcoin/presentation/states/fitcoin_states.dart';
import 'package:fitcoin/core/cache/cache_service.dart';

class FitcoinController extends StateNotifier<FitcoinState> {
  final GetFitcoinBalance _getFitcoinBalance;
  final ConvertStepsToFitcoins _convertStepsToFitcoins;

  FitcoinBalance? _lastBalance;
  bool _isRefreshing = false;

  FitcoinController({
    required GetFitcoinBalance getFitcoinBalance,
    required ConvertStepsToFitcoins convertStepsToFitcoins,
  })  : _getFitcoinBalance = getFitcoinBalance,
        _convertStepsToFitcoins = convertStepsToFitcoins,
        super(FitcoinInitial());

  Future<void> loadBalance() async {
    // ✅ Check token expiry before making request
    if (CacheService.isTokenExpired()) {
      print('🔴 Token expired, refreshing...');
      // The refresh will happen in the remote source
    }

    state = FitcoinLoading(balance: _lastBalance);
    final result = await _getFitcoinBalance();

    result.fold(
          (failure) {
        // ✅ If error is due to auth, try one more time
        if (failure.message.contains('expired') ||
            failure.message.contains('Unauthorized') ||
            failure.message.contains('401')) {
          print('🔄 Retrying balance load after refresh...');
          _retryLoadBalance();
        } else {
          state = FitcoinError(failure.message, balance: _lastBalance);
        }
      },
          (balance) {
        _lastBalance = balance;
        state = FitcoinLoaded(balance);
      },
    );
  }

  Future<void> _retryLoadBalance() async {
    if (_isRefreshing) return;
    _isRefreshing = true;

    // Wait a bit for token refresh to complete
    await Future.delayed(const Duration(milliseconds: 500));

    final result = await _getFitcoinBalance();
    _isRefreshing = false;

    result.fold(
          (failure) => state = FitcoinError(failure.message, balance: _lastBalance),
          (balance) {
        _lastBalance = balance;
        state = FitcoinLoaded(balance);
      },
    );
  }

  Future<void> convertSteps(int stepsToConvert) async {
    // ✅ Check token expiry before making request
    if (CacheService.isTokenExpired()) {
      print('🔴 Token expired during conversion, refreshing...');
    }

    state = FitcoinConverting(balance: _lastBalance);
    final result = await _convertStepsToFitcoins(stepsToConvert);

    result.fold(
          (failure) {
        // ✅ If error is due to auth, try one more time
        if (failure.message.contains('expired') ||
            failure.message.contains('Unauthorized') ||
            failure.message.contains('401')) {
          print('🔄 Retrying conversion after refresh...');
          _retryConvertSteps(stepsToConvert);
        } else {
          state = FitcoinError(failure.message, balance: _lastBalance);
        }
      },
          (convertResult) {
        _lastBalance = FitcoinBalance(
          fitcoinBalance: convertResult.fitcoinBalance,
          todayAvailableSteps: convertResult.remainingSteps,
          conversionRate: convertResult.conversionRate,
        );
        state = FitcoinSuccess(convertResult, balance: _lastBalance);
      },
    );
  }

  Future<void> _retryConvertSteps(int stepsToConvert) async {
    if (_isRefreshing) return;
    _isRefreshing = true;

    await Future.delayed(const Duration(milliseconds: 500));

    final result = await _convertStepsToFitcoins(stepsToConvert);
    _isRefreshing = false;

    result.fold(
          (failure) => state = FitcoinError(failure.message, balance: _lastBalance),
          (convertResult) {
        _lastBalance = FitcoinBalance(
          fitcoinBalance: convertResult.fitcoinBalance,
          todayAvailableSteps: convertResult.remainingSteps,
          conversionRate: convertResult.conversionRate,
        );
        state = FitcoinSuccess(convertResult, balance: _lastBalance);
      },
    );
  }

  void reset() {
    state = FitcoinInitial();
    _lastBalance = null;
  }
}