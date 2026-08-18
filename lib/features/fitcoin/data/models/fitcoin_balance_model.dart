import 'package:fitcoin/features/fitcoin/domain/entities/fitcoin_balance.dart';

class FitcoinBalanceModel extends FitcoinBalance {
  const FitcoinBalanceModel({
    required super.fitcoinBalance,
    required super.todayAvailableSteps,
    required super.conversionRate,
  });

  factory FitcoinBalanceModel.fromJson(Map<String, dynamic> json) {
    return FitcoinBalanceModel(
      fitcoinBalance: json['fitcoin_balance'] ?? 0,
      todayAvailableSteps: json['today_available_steps'] ?? 0,
      conversionRate: json['conversion_rate'] ?? 1000,
    );
  }
}