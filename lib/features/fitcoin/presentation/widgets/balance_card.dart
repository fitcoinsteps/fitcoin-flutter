import 'package:flutter/material.dart';
import 'package:fitcoin/core/theme/app_colors.dart';
import 'package:fitcoin/features/fitcoin/domain/entities/fitcoin_balance.dart';

class BalanceCard extends StatelessWidget {
  final FitcoinBalance balance;

  const BalanceCard({super.key, required this.balance});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Fitcoin Balance',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Icon(Icons.monetization_on, color: AppColors.primaryPink),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              '${balance.fitcoinBalance}',
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryPink,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Available Steps Today: ${balance.todayAvailableSteps}',
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 4),
            Text(
              'Rate: ${balance.conversionRate} steps = 1 Fitcoin',
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}