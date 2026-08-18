import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Shared text styles for the FitCoin brand theme.
/// Swap [fontFamily] for whatever font is registered in pubspec.yaml.
class AppTextStyles {
  AppTextStyles._();

  static const String fontFamily = 'Poppins';

  static const TextStyle brandTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: Colors.white, // overridden by ShaderMask in BrandMark
    letterSpacing: 0.4,
  );

  static const TextStyle heading = TextStyle(
    fontFamily: fontFamily,
    fontSize: 26,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle subheading = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static const TextStyle inputText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  static const TextStyle buttonLabel = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    letterSpacing: 0.3,
  );

  static const TextStyle linkText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryPink,
  );

  static const TextStyle footerText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    color: AppColors.textMuted,
    letterSpacing: 0.3,
  );
}