import 'package:fitcoin/features/fitcoin/domain/entities/fitcoin_convert_result.dart';

class FitcoinConvertResponseModel extends FitcoinConvertResult {
  const FitcoinConvertResponseModel({
    required super.fitcoinsEarned,
    required super.fitcoinBalance,
    required super.remainingSteps,
    required super.conversionRate,
  });

  factory FitcoinConvertResponseModel.fromJson(Map<String, dynamic> json) {
    return FitcoinConvertResponseModel(
      fitcoinsEarned: json['fitcoins_earned'] ?? 0,
      fitcoinBalance: json['fitcoin_balance'] ?? 0,
      remainingSteps: json['remaining_steps'] ?? 0,
      conversionRate: json['conversion_rate'] ?? 1000,
    );
  }
}