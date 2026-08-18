import 'package:flutter/material.dart';
import 'package:fitcoin/core/theme/app_colors.dart';
import 'package:fitcoin/features/step_counter/domain/entities/step_data.dart';

class StepProgressCard extends StatelessWidget {
  final StepData stepData;
  final bool isSyncing;

  const StepProgressCard({
    super.key,
    required this.stepData,
    this.isSyncing = false,
  });

  @override
  Widget build(BuildContext context) {
    final progress = stepData.progress.clamp(0.0, 1.0);
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
                  'Today\'s Steps',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                if (isSyncing)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              '${stepData.steps}',
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryPink,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Goal: ${stepData.goal}',
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: AppColors.primaryPink.withValues(alpha: 0.2),
              valueColor: const AlwaysStoppedAnimation(AppColors.primaryPink),
              borderRadius: BorderRadius.circular(5),
            ),
            const SizedBox(height: 8),
            Text(
              '${(progress * 100).toStringAsFixed(1)}% of goal reached',
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}