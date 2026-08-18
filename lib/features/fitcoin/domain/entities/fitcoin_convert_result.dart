class FitcoinConvertResult {
  final int fitcoinsEarned;
  final int fitcoinBalance;
  final int remainingSteps;
  final int conversionRate;

  const FitcoinConvertResult({
    required this.fitcoinsEarned,
    required this.fitcoinBalance,
    required this.remainingSteps,
    required this.conversionRate,
  });
}