import 'package:fitcoin/features/fitcoin/domain/entities/fitcoin_balance.dart';
import 'package:fitcoin/features/fitcoin/domain/entities/fitcoin_convert_result.dart';

sealed class FitcoinState {
  final FitcoinBalance? balance;

  const FitcoinState({this.balance});
}

class FitcoinInitial extends FitcoinState {
  const FitcoinInitial();
}

class FitcoinLoading extends FitcoinState {
  const FitcoinLoading({FitcoinBalance? balance}) : super(balance: balance);
}

class FitcoinLoaded extends FitcoinState {
  const FitcoinLoaded(FitcoinBalance balance) : super(balance: balance);
}

class FitcoinConverting extends FitcoinState {
  const FitcoinConverting({FitcoinBalance? balance}) : super(balance: balance);
}

class FitcoinError extends FitcoinState {
  final String message;
  const FitcoinError(this.message, {FitcoinBalance? balance}) : super(balance: balance);
}

class FitcoinSuccess extends FitcoinState {
  final FitcoinConvertResult result;
  const FitcoinSuccess(this.result, {FitcoinBalance? balance}) : super(balance: balance);
}