import 'package:flutter/material.dart';
import '../app_colors.dart';
import '../app_text_styles.dart';

/// Logo + gradient wordmark shown at the top of every auth screen
/// (Welcome, Login, Register, OTP). Swap the [Icon] for the real
/// FitCoin coin logo asset (e.g. Image.asset) once it's in the project.
class BrandMark extends StatelessWidget {
  final double size;

  const BrandMark({super.key, this.size = 84});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: size,
          width: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppColors.primaryGradient,
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryPurple.withValues(alpha: 0.5),
                blurRadius: 28,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Icon(
            Icons.directions_run_rounded,
            color: Colors.white,
            size: size * 0.45,
          ),
        ),
        const SizedBox(height: 14),
        ShaderMask(
          shaderCallback: (bounds) => AppColors.primaryGradient.createShader(bounds),
          blendMode: BlendMode.srcIn,
          child: const Text('Fit Coin', style: AppTextStyles.brandTitle),
        ),
      ],
    );
  }
}