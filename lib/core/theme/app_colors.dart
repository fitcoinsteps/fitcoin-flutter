import 'package:flutter/material.dart';

/// Central FitCoin brand palette.
///
/// Dark cosmic / liquid-glass visual system used across:
/// - Welcome
/// - Login
/// - Register
/// - OTP
/// - Glass buttons
/// - Cards / inputs
class AppColors {
  AppColors._();

  // ==========================================================================
  // BACKGROUND
  // ==========================================================================

  /// Darker main purple-black background.
  static const Color backgroundTop = Color(0xFF10081B);

  /// Very deep bottom background.
  static const Color backgroundBottom = Color(0xFF05030A);

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      backgroundTop,
      backgroundBottom,
    ],
  );

  /// Very dark purple used inside glass surfaces.
  static const Color glassPurple = Color(0xFF1B1425);

  /// Very dark pink used inside glass surfaces.
  static const Color glassPink = Color(0xFF21131C);

  // ==========================================================================
  // BRAND ACCENTS
  // ==========================================================================

  static const Color primaryPurple = Color(0xFF9B4DFF);

  static const Color primaryPink = Color(0xFFEC4899);

  static const Color accentGold = Color(0xFFF3C15E);

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      primaryPurple,
      primaryPink,
    ],
  );

  // ==========================================================================
  // DARK LIQUID GLASS COLORS
  // ==========================================================================

  /// Dim purple used for atmospheric background lighting.
  static const Color liquidPurple = Color(0xFF4D287D);

  /// Dim pink used for atmospheric background lighting.
  static const Color liquidPink = Color(0xFF692D50);

  /// Dark purple used inside glass components.
  static const Color liquidPurpleDark = Color(0xFF2A1938);

  /// Dark pink used inside glass components.
  static const Color liquidPinkDark = Color(0xFF301824);

  /// Neutral dark glass.
  static const Color glassDark = Color(0xFF121018);

  // ==========================================================================
  // GLASS SURFACES
  // ==========================================================================

  static final Color glassFill =
  Colors.white.withValues(alpha: 0.055);

  static final Color glassBorder =
  Colors.white.withValues(alpha: 0.14);

  static final Color inputFill =
  Colors.white.withValues(alpha: 0.035);

  /// Dark translucent glass fill for premium surfaces.
  static final Color darkGlassFill =
  glassDark.withValues(alpha: 0.72);

  /// Very subtle purple glass tint.
  static final Color purpleGlassTint =
  liquidPurpleDark.withValues(alpha: 0.26);

  /// Very subtle pink glass tint.
  static final Color pinkGlassTint =
  liquidPinkDark.withValues(alpha: 0.20);

  // ==========================================================================
  // TEXT
  // ==========================================================================

  static const Color textPrimary = Colors.white;

  static const Color textSecondary = Color(0xFFC9BEDD);

  static const Color textMuted = Color(0xFF8B80A0);

  // ==========================================================================
  // STATUS
  // ==========================================================================

  static const Color error = Color(0xFFFF5C6C);

  static final Color errorFill =
  const Color(0xFFFF5C6C).withValues(alpha: 0.10);

  static final Color errorBorder =
  const Color(0xFFFF5C6C).withValues(alpha: 0.35);
}