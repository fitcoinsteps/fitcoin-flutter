import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import '../app_colors.dart';

/// Dark cosmic / liquid-glass background used across the FitCoin app.
///
/// Visual system:
/// - Very dark purple / black cosmic background
/// - Subtle purple / pink atmosphere
/// - Dense fixed starfield
/// - ONE dominant extra-bold wavy fire trail
/// - Trail flows TOP-RIGHT -> BOTTOM-LEFT
/// - Multiple connected outward fire branches
/// - Large pink firework explosions
/// - Four-point sparkles
/// - Hot particles and flying embers
///
/// The result should feel like a glowing burning cosmic object travelling
/// diagonally across the screen.
class StarfieldBackground extends StatelessWidget {
  final Widget child;
  final int starCount;

  const StarfieldBackground({
    super.key,
    required this.child,
    this.starCount = 90,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: AppColors.backgroundGradient,
          ),
        ),

        CustomPaint(
          painter: _StarfieldPainter(
            starCount: starCount,
          ),
        ),

        child,
      ],
    );
  }
}

// ============================================================================
// STARFIELD PAINTER
// ============================================================================

class _StarfieldPainter extends CustomPainter {
  final int starCount;

  // Global dimming factor for all pink elements (0.45 = much darker)
  static const double _dimFactor = 0.45;

  const _StarfieldPainter({
    required this.starCount,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) {
      return;
    }

    // ------------------------------------------------------------------------
    // BACKGROUND ATMOSPHERE (dimmed)
    // ------------------------------------------------------------------------

    _paintGlow(
      canvas,
      Offset(
        size.width * 0.02,
        size.height * 0.08,
      ),
      AppColors.primaryPurple,
      270,
      opacity: 0.085,
    );

    _paintGlow(
      canvas,
      Offset(
        size.width * 0.98,
        size.height * 0.08,
      ),
      AppColors.primaryPink,
      260,
      opacity: 0.075 * _dimFactor, // dimmed
    );

    _paintGlow(
      canvas,
      Offset(
        size.width * 0.84,
        size.height * 0.78,
      ),
      AppColors.primaryPurple,
      300,
      opacity: 0.060,
    );

    _paintGlow(
      canvas,
      Offset(
        size.width * 0.06,
        size.height * 0.92,
      ),
      AppColors.primaryPink,
      270,
      opacity: 0.045 * _dimFactor, // dimmed
    );

    _paintCenterMix(canvas, size);

    // ------------------------------------------------------------------------
    // STARS
    // ------------------------------------------------------------------------

    _paintStars(canvas, size);

    // ------------------------------------------------------------------------
    // MAIN COSMIC FIRE SYSTEM
    // ------------------------------------------------------------------------

    _paintFireworks(canvas, size);
  }

  // ==========================================================================
  // STARS (unchanged)
  // ==========================================================================

  void _paintStars(
      Canvas canvas,
      Size size,
      ) {
    final random = Random(7);

    for (var i = 0; i < starCount; i++) {
      final dx = random.nextDouble() * size.width;
      final dy = random.nextDouble() * size.height;

      final radius =
          random.nextDouble() * 1.15 + 0.20;

      final opacity =
          random.nextDouble() * 0.36 + 0.06;

      final paint = Paint()
        ..color = Colors.white.withValues(
          alpha: opacity,
        );

      canvas.drawCircle(
        Offset(dx, dy),
        radius,
        paint,
      );
    }

    // ------------------------------------------------------------------------
    // SOFT DISTANT STARS
    // ------------------------------------------------------------------------

    final glowRandom = Random(17);

    for (var i = 0; i < 14; i++) {
      final dx = glowRandom.nextDouble() * size.width;
      final dy = glowRandom.nextDouble() * size.height;

      final radius =
          glowRandom.nextDouble() * 1.4 + 0.7;

      final paint = Paint()
        ..color = Colors.white.withValues(
          alpha: 0.055,
        )
        ..maskFilter = const MaskFilter.blur(
          BlurStyle.normal,
          3.5,
        );

      canvas.drawCircle(
        Offset(dx, dy),
        radius,
        paint,
      );
    }
  }

  // ==========================================================================
  // MAIN FIREWORK SYSTEM
  // ==========================================================================

  void _paintFireworks(
      Canvas canvas,
      Size size,
      ) {
    final origin = Offset(
      size.width * 1.045,
      size.height * 0.025,
    );

    // =========================================================================
    // MAIN TRAIL
    // =========================================================================

    final mainPath = _createMainTrail(size);

    // -------------------------------------------------------------------------
    // MAIN THICK TRAIL
    // -------------------------------------------------------------------------

    _paintMainCosmicTrail(
      canvas,
      mainPath,
    );

    // -------------------------------------------------------------------------
    // HOT INNER CORE
    // -------------------------------------------------------------------------

    _paintHotCore(
      canvas,
      mainPath,
    );

    // =========================================================================
    // BRANCHES
    // =========================================================================

    final branches = _createBranches(size);

    for (final branch in branches) {
      final path = _createBranchPath(
        branch.anchor,
        branch.end,
        branch.curve,
      );

      _paintThickTrail(
        canvas,
        path,
        opacity: branch.opacity,
        width: branch.width,
      );

      _paintTrailParticles(
        canvas,
        branch.anchor,
        branch.end,
        branch.seed,
        branch.opacity,
      );

      _paintFireworkBurst(
        canvas,
        branch.end,
        radius: size.width * branch.burstRadius,
        rays: branch.rays,
        seed: branch.seed,
        opacity: branch.opacity,
      );

      // Small sparkle just beyond explosion.
      final sparkleOffset = Offset(
        branch.end.dx +
            (branch.end.dx - branch.anchor.dx) * 0.13,
        branch.end.dy +
            (branch.end.dy - branch.anchor.dy) * 0.13,
      );

      _paintSparkle(
        canvas,
        sparkleOffset,
        size.width * 0.010,
        branch.opacity * 0.82,
      );
    }

    // =========================================================================
    // LARGE PRIMARY EXPLOSIONS (dimmed)
    // =========================================================================

    _paintFireworkBurst(
      canvas,
      Offset(
        size.width * 0.835,
        size.height * 0.130,
      ),
      radius: size.width * 0.056,
      rays: 24,
      seed: 900,
      opacity: 0.88 * _dimFactor,
    );

    _paintFireworkBurst(
      canvas,
      Offset(
        size.width * 0.695,
        size.height * 0.300,
      ),
      radius: size.width * 0.047,
      rays: 21,
      seed: 901,
      opacity: 0.82 * _dimFactor,
    );

    _paintFireworkBurst(
      canvas,
      Offset(
        size.width * 0.515,
        size.height * 0.350,
      ),
      radius: size.width * 0.060,
      rays: 26,
      seed: 902,
      opacity: 0.90 * _dimFactor,
    );

    _paintFireworkBurst(
      canvas,
      Offset(
        size.width * 0.285,
        size.height * 0.585,
      ),
      radius: size.width * 0.058,
      rays: 25,
      seed: 903,
      opacity: 0.87 * _dimFactor,
    );

    _paintFireworkBurst(
      canvas,
      Offset(
        size.width * 0.065,
        size.height * 0.875,
      ),
      radius: size.width * 0.095,
      rays: 32,
      seed: 999,
      opacity: 0.98 * _dimFactor,
    );

    // =========================================================================
    // FREE FLOATING SPARKLES (dimmed)
    // =========================================================================

    final sparklePositions = <Offset>[
      Offset(size.width * 0.955, size.height * 0.145),
      Offset(size.width * 0.920, size.height * 0.245),
      Offset(size.width * 0.875, size.height * 0.060),
      Offset(size.width * 0.805, size.height * 0.245),
      Offset(size.width * 0.755, size.height * 0.075),
      Offset(size.width * 0.725, size.height * 0.395),
      Offset(size.width * 0.670, size.height * 0.105),
      Offset(size.width * 0.625, size.height * 0.465),
      Offset(size.width * 0.580, size.height * 0.155),
      Offset(size.width * 0.545, size.height * 0.535),
      Offset(size.width * 0.470, size.height * 0.235),
      Offset(size.width * 0.445, size.height * 0.625),
      Offset(size.width * 0.390, size.height * 0.355),
      Offset(size.width * 0.365, size.height * 0.705),
      Offset(size.width * 0.315, size.height * 0.430),
      Offset(size.width * 0.285, size.height * 0.750),
      Offset(size.width * 0.235, size.height * 0.505),
      Offset(size.width * 0.205, size.height * 0.820),
      Offset(size.width * 0.150, size.height * 0.630),
      Offset(size.width * 0.120, size.height * 0.850),
      Offset(size.width * 0.075, size.height * 0.715),
      Offset(size.width * 0.040, size.height * 0.805),
    ];

    for (var i = 0; i < sparklePositions.length; i++) {
      _paintSparkle(
        canvas,
        sparklePositions[i],
        size.width *
            (0.008 + (i % 6) * 0.0028),
        (0.38 + (i % 6) * 0.085) * _dimFactor,
      );
    }

    // =========================================================================
    // LARGE DISTANT SPARKLES (dimmed)
    // =========================================================================

    _paintSparkle(
      canvas,
      Offset(
        size.width * 0.91,
        size.height * 0.31,
      ),
      size.width * 0.026,
      0.82 * _dimFactor,
    );

    _paintSparkle(
      canvas,
      Offset(
        size.width * 0.645,
        size.height * 0.525,
      ),
      size.width * 0.021,
      0.76 * _dimFactor,
    );

    _paintSparkle(
      canvas,
      Offset(
        size.width * 0.365,
        size.height * 0.735,
      ),
      size.width * 0.025,
      0.79 * _dimFactor,
    );

    _paintSparkle(
      canvas,
      Offset(
        size.width * 0.115,
        size.height * 0.545,
      ),
      size.width * 0.019,
      0.72 * _dimFactor,
    );

    // =========================================================================
    // FLYING EMBERS (dimmed)
    // =========================================================================

    _paintFlyingEmbers(
      canvas,
      size,
    );

    // =========================================================================
    // ORIGIN (dimmed)
    // =========================================================================

    _paintOrigin(
      canvas,
      origin,
    );
  }

  // ==========================================================================
  // MAIN TRAIL GEOMETRY (unchanged)
  // ==========================================================================

  Path _createMainTrail(Size size) {
    final path = Path();

    final w = size.width;
    final h = size.height;

    path.moveTo(
      w * 1.055,
      h * 0.025,
    );

    // WAVE 1
    path.cubicTo(
      w * 0.995,
      h * 0.030,
      w * 0.935,
      h * 0.095,
      w * 0.845,
      h * 0.130,
    );

    // WAVE 2
    path.cubicTo(
      w * 0.765,
      h * 0.165,
      w * 0.800,
      h * 0.245,
      w * 0.710,
      h * 0.300,
    );

    // WAVE 3
    path.cubicTo(
      w * 0.630,
      h * 0.350,
      w * 0.555,
      h * 0.275,
      w * 0.505,
      h * 0.350,
    );

    // WAVE 4
    path.cubicTo(
      w * 0.455,
      h * 0.425,
      w * 0.535,
      h * 0.465,
      w * 0.445,
      h * 0.520,
    );

    // WAVE 5
    path.cubicTo(
      w * 0.370,
      h * 0.565,
      w * 0.325,
      h * 0.515,
      w * 0.280,
      h * 0.590,
    );

    // WAVE 6
    path.cubicTo(
      w * 0.225,
      h * 0.675,
      w * 0.295,
      h * 0.680,
      w * 0.205,
      h * 0.735,
    );

    // WAVE 7
    path.cubicTo(
      w * 0.145,
      h * 0.775,
      w * 0.125,
      h * 0.830,
      w * 0.065,
      h * 0.875,
    );

    // FINAL WAVE OUT OF SCREEN
    path.cubicTo(
      w * 0.040,
      h * 0.895,
      w * 0.020,
      h * 0.910,
      w * -0.035,
      h * 0.935,
    );

    return path;
  }

  // ==========================================================================
  // BRANCH DEFINITIONS (opacity values already multiplied later)
  // ==========================================================================

  List<_FireworkBranch> _createBranches(Size size) {
    final w = size.width;
    final h = size.height;

    return [
      // (same as before, but we'll multiply opacity when drawing)
      _FireworkBranch(
        anchor: Offset(w * 0.895, h * 0.105),
        end: Offset(w * 0.770, h * 0.025),
        curve: -28,
        width: 3.0,
        opacity: 0.78,
        burstRadius: 0.034,
        rays: 14,
        seed: 101,
      ),
      _FireworkBranch(
        anchor: Offset(w * 0.865, h * 0.120),
        end: Offset(w * 0.965, h * 0.035),
        curve: 27,
        width: 2.7,
        opacity: 0.72,
        burstRadius: 0.031,
        rays: 13,
        seed: 102,
      ),
      _FireworkBranch(
        anchor: Offset(w * 0.825, h * 0.135),
        end: Offset(w * 0.700, h * 0.055),
        curve: -35,
        width: 2.8,
        opacity: 0.76,
        burstRadius: 0.035,
        rays: 14,
        seed: 103,
      ),
      _FireworkBranch(
        anchor: Offset(w * 0.785, h * 0.170),
        end: Offset(w * 0.875, h * 0.285),
        curve: 36,
        width: 3.0,
        opacity: 0.80,
        burstRadius: 0.039,
        rays: 16,
        seed: 104,
      ),
      _FireworkBranch(
        anchor: Offset(w * 0.735, h * 0.285),
        end: Offset(w * 0.625, h * 0.195),
        curve: -34,
        width: 2.8,
        opacity: 0.73,
        burstRadius: 0.032,
        rays: 13,
        seed: 105,
      ),
      _FireworkBranch(
        anchor: Offset(w * 0.710, h * 0.300),
        end: Offset(w * 0.790, h * 0.410),
        curve: 37,
        width: 3.1,
        opacity: 0.82,
        burstRadius: 0.040,
        rays: 17,
        seed: 106,
      ),
      _FireworkBranch(
        anchor: Offset(w * 0.660, h * 0.315),
        end: Offset(w * 0.535, h * 0.225),
        curve: -30,
        width: 2.7,
        opacity: 0.70,
        burstRadius: 0.030,
        rays: 13,
        seed: 107,
      ),
      _FireworkBranch(
        anchor: Offset(w * 0.575, h * 0.315),
        end: Offset(w * 0.605, h * 0.165),
        curve: 28,
        width: 2.9,
        opacity: 0.75,
        burstRadius: 0.034,
        rays: 14,
        seed: 108,
      ),
      _FireworkBranch(
        anchor: Offset(w * 0.520, h * 0.345),
        end: Offset(w * 0.395, h * 0.255),
        curve: -37,
        width: 3.0,
        opacity: 0.80,
        burstRadius: 0.039,
        rays: 16,
        seed: 109,
      ),
      _FireworkBranch(
        anchor: Offset(w * 0.485, h * 0.410),
        end: Offset(w * 0.565, h * 0.520),
        curve: 39,
        width: 2.9,
        opacity: 0.76,
        burstRadius: 0.035,
        rays: 14,
        seed: 110,
      ),
      _FireworkBranch(
        anchor: Offset(w * 0.455, h * 0.475),
        end: Offset(w * 0.335, h * 0.395),
        curve: -34,
        width: 2.8,
        opacity: 0.74,
        burstRadius: 0.032,
        rays: 13,
        seed: 111,
      ),
      _FireworkBranch(
        anchor: Offset(w * 0.425, h * 0.525),
        end: Offset(w * 0.500, h * 0.655),
        curve: 38,
        width: 3.1,
        opacity: 0.82,
        burstRadius: 0.040,
        rays: 17,
        seed: 112,
      ),
      _FireworkBranch(
        anchor: Offset(w * 0.370, h * 0.545),
        end: Offset(w * 0.245, h * 0.455),
        curve: -39,
        width: 2.8,
        opacity: 0.72,
        burstRadius: 0.032,
        rays: 14,
        seed: 113,
      ),
      _FireworkBranch(
        anchor: Offset(w * 0.320, h * 0.565),
        end: Offset(w * 0.365, h * 0.700),
        curve: 38,
        width: 3.0,
        opacity: 0.80,
        burstRadius: 0.038,
        rays: 16,
        seed: 114,
      ),
      _FireworkBranch(
        anchor: Offset(w * 0.285, h * 0.595),
        end: Offset(w * 0.165, h * 0.515),
        curve: -34,
        width: 2.8,
        opacity: 0.73,
        burstRadius: 0.032,
        rays: 14,
        seed: 115,
      ),
      _FireworkBranch(
        anchor: Offset(w * 0.250, h * 0.650),
        end: Offset(w * 0.300, h * 0.790),
        curve: 40,
        width: 3.2,
        opacity: 0.84,
        burstRadius: 0.042,
        rays: 18,
        seed: 116,
      ),
      _FireworkBranch(
        anchor: Offset(w * 0.215, h * 0.715),
        end: Offset(w * 0.095, h * 0.635),
        curve: -37,
        width: 2.9,
        opacity: 0.77,
        burstRadius: 0.034,
        rays: 14,
        seed: 117,
      ),
      _FireworkBranch(
        anchor: Offset(w * 0.185, h * 0.750),
        end: Offset(w * 0.235, h * 0.885),
        curve: 41,
        width: 3.2,
        opacity: 0.86,
        burstRadius: 0.043,
        rays: 18,
        seed: 118,
      ),
      _FireworkBranch(
        anchor: Offset(w * 0.140, h * 0.795),
        end: Offset(w * 0.050, h * 0.720),
        curve: -31,
        width: 2.8,
        opacity: 0.76,
        burstRadius: 0.033,
        rays: 14,
        seed: 119,
      ),
      _FireworkBranch(
        anchor: Offset(w * 0.090, h * 0.850),
        end: Offset(w * 0.120, h * 0.975),
        curve: 37,
        width: 3.3,
        opacity: 0.90,
        burstRadius: 0.046,
        rays: 19,
        seed: 120,
      ),
      _FireworkBranch(
        anchor: Offset(w * 0.945, h * 0.070),
        end: Offset(w * 0.860, h * -0.005),
        curve: -20,
        width: 2.2,
        opacity: 0.60,
        burstRadius: 0.026,
        rays: 11,
        seed: 121,
      ),
      _FireworkBranch(
        anchor: Offset(w * 0.620, h * 0.305),
        end: Offset(w * 0.690, h * 0.185),
        curve: 24,
        width: 2.4,
        opacity: 0.66,
        burstRadius: 0.028,
        rays: 12,
        seed: 122,
      ),
      _FireworkBranch(
        anchor: Offset(w * 0.390, h * 0.555),
        end: Offset(w * 0.430, h * 0.430),
        curve: 27,
        width: 2.5,
        opacity: 0.68,
        burstRadius: 0.029,
        rays: 12,
        seed: 123,
      ),
      _FireworkBranch(
        anchor: Offset(w * 0.205, h * 0.735),
        end: Offset(w * 0.145, h * 0.875),
        curve: 25,
        width: 2.5,
        opacity: 0.68,
        burstRadius: 0.030,
        rays: 12,
        seed: 124,
      ),
    ];
  }

  // ==========================================================================
  // BRANCH PATH (unchanged)
  // ==========================================================================

  Path _createBranchPath(
      Offset start,
      Offset end,
      double curve,
      ) {
    final path = Path();

    path.moveTo(
      start.dx,
      start.dy,
    );

    final dx = end.dx - start.dx;
    final dy = end.dy - start.dy;

    final length = sqrt(
      dx * dx + dy * dy,
    );

    if (length == 0) {
      return path;
    }

    final normalX = -dy / length;
    final normalY = dx / length;

    final control = Offset(
      (start.dx + end.dx) / 2 +
          normalX * curve,
      (start.dy + end.dy) / 2 +
          normalY * curve,
    );

    path.quadraticBezierTo(
      control.dx,
      control.dy,
      end.dx,
      end.dy,
    );

    return path;
  }

  // ==========================================================================
  // MAIN COSMIC TRAIL (all pink dimmed)
  // ==========================================================================

  void _paintMainCosmicTrail(
      Canvas canvas,
      Path path,
      ) {
    // ------------------------------------------------------------------------
    // HUGE OUTER GLOW
    // ------------------------------------------------------------------------

    final outerGlow = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 24
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = AppColors.primaryPink.withValues(
        alpha: 0.045 * _dimFactor,
      )
      ..maskFilter = const MaskFilter.blur(
        BlurStyle.normal,
        18,
      );

    canvas.drawPath(
      path,
      outerGlow,
    );

    // ------------------------------------------------------------------------
    // STRONG OUTER PINK GLOW
    // ------------------------------------------------------------------------

    final glow1 = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = AppColors.primaryPink.withValues(
        alpha: 0.085 * _dimFactor,
      )
      ..maskFilter = const MaskFilter.blur(
        BlurStyle.normal,
        12,
      );

    canvas.drawPath(
      path,
      glow1,
    );

    // ------------------------------------------------------------------------
    // SECOND GLOW
    // ------------------------------------------------------------------------

    final glow2 = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = AppColors.primaryPink.withValues(
        alpha: 0.14 * _dimFactor,
      )
      ..maskFilter = const MaskFilter.blur(
        BlurStyle.normal,
        6,
      );

    canvas.drawPath(
      path,
      glow2,
    );

    // ------------------------------------------------------------------------
    // EXTRA-BOLD MAIN BODY
    // ------------------------------------------------------------------------

    final body = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = AppColors.primaryPink.withValues(
        alpha: 0.62 * _dimFactor,
      );

    canvas.drawPath(
      path,
      body,
    );

    // ------------------------------------------------------------------------
    // BRIGHTER INNER BODY
    // ------------------------------------------------------------------------

    final inner = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.1
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = AppColors.primaryPink.withValues(
        alpha: 0.78 * _dimFactor,
      );

    canvas.drawPath(
      path,
      inner,
    );

    // ------------------------------------------------------------------------
    // HOT PINK/WHITE CENTER (dimmed slightly)
    // ------------------------------------------------------------------------

    final center = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.7
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = Colors.white.withValues(
        alpha: 0.45, // reduced from 0.55
      );

    canvas.drawPath(
      path,
      center,
    );
  }

  // ==========================================================================
  // HOT CORE (dimmed white)
  // ==========================================================================

  void _paintHotCore(
      Canvas canvas,
      Path path,
      ) {
    final hotCore = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8
      ..strokeCap = StrokeCap.round
      ..color = Colors.white.withValues(
        alpha: 0.50, // reduced from 0.70
      );

    canvas.drawPath(
      path,
      hotCore,
    );
  }

  // ==========================================================================
  // BRANCH TRAIL (all pink dimmed)
  // ==========================================================================

  void _paintThickTrail(
      Canvas canvas,
      Path path, {
        required double opacity,
        required double width,
      }) {
    // Apply dimming to the branch's own opacity
    final effectiveOpacity = opacity * _dimFactor;

    // ------------------------------------------------------------------------
    // BRANCH OUTER GLOW
    // ------------------------------------------------------------------------

    final glow = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = width * 5.8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = AppColors.primaryPink.withValues(
        alpha: effectiveOpacity * 0.075,
      )
      ..maskFilter = const MaskFilter.blur(
        BlurStyle.normal,
        10,
      );

    canvas.drawPath(
      path,
      glow,
    );

    // ------------------------------------------------------------------------
    // BRANCH INNER GLOW
    // ------------------------------------------------------------------------

    final glow2 = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = width * 2.7
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = AppColors.primaryPink.withValues(
        alpha: effectiveOpacity * 0.19,
      )
      ..maskFilter = const MaskFilter.blur(
        BlurStyle.normal,
        4,
      );

    canvas.drawPath(
      path,
      glow2,
    );

    // ------------------------------------------------------------------------
    // MAIN BRANCH
    // ------------------------------------------------------------------------

    final line = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = AppColors.primaryPink.withValues(
        alpha: effectiveOpacity * 0.64,
      );

    canvas.drawPath(
      path,
      line,
    );

    // ------------------------------------------------------------------------
    // BRANCH HOT CENTER (white, dimmed)
    // ------------------------------------------------------------------------

    final highlight = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = width * 0.25
      ..strokeCap = StrokeCap.round
      ..color = Colors.white.withValues(
        alpha: effectiveOpacity * 0.30,
      );

    canvas.drawPath(
      path,
      highlight,
    );
  }

  // ==========================================================================
  // BRANCH PARTICLES (dimmed)
  // ==========================================================================

  void _paintTrailParticles(
      Canvas canvas,
      Offset start,
      Offset end,
      int seed,
      double opacity,
      ) {
    final random = Random(seed + 500);
    final effOpacity = opacity * _dimFactor;

    for (var i = 0; i < 13; i++) {
      final t =
          0.08 +
              random.nextDouble() * 0.86;

      final x =
          start.dx +
              (end.dx - start.dx) * t;

      final y =
          start.dy +
              (end.dy - start.dy) * t;

      final spread =
          11 +
              random.nextDouble() * 22;

      final offset = Offset(
        x +
            (random.nextDouble() - 0.5) *
                spread,
        y +
            (random.nextDouble() - 0.5) *
                spread,
      );

      final radius =
          random.nextDouble() * 1.25 +
              0.25;

      final paint = Paint()
        ..color = AppColors.primaryPink.withValues(
          alpha: effOpacity *
              (0.20 +
                  random.nextDouble() * 0.38),
        )
        ..maskFilter = const MaskFilter.blur(
          BlurStyle.normal,
          1.5,
        );

      canvas.drawCircle(
        offset,
        radius,
        paint,
      );
    }
  }

  // ==========================================================================
  // FLYING EMBERS (dimmed)
  // ==========================================================================

  void _paintFlyingEmbers(
      Canvas canvas,
      Size size,
      ) {
    final random = Random(777);

    for (var i = 0; i < 65; i++) {
      final x =
          random.nextDouble() *
              size.width;

      final y =
          random.nextDouble() *
              size.height;

      final radius =
          random.nextDouble() * 1.15 +
              0.20;

      final paint = Paint()
        ..color = AppColors.primaryPink.withValues(
          alpha:
          (0.07 +
              random.nextDouble() * 0.20) * _dimFactor,
        )
        ..maskFilter = const MaskFilter.blur(
          BlurStyle.normal,
          1.3,
        );

      canvas.drawCircle(
        Offset(x, y),
        radius,
        paint,
      );
    }
  }

  // ==========================================================================
  // FIREWORK BURST (dimmed)
  // ==========================================================================

  void _paintFireworkBurst(
      Canvas canvas,
      Offset center, {
        required double radius,
        required int rays,
        required int seed,
        required double opacity,
      }) {
    final effOpacity = opacity * _dimFactor;

    // ------------------------------------------------------------------------
    // LARGE ATMOSPHERIC GLOW
    // ------------------------------------------------------------------------

    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          AppColors.primaryPink.withValues(
            alpha: effOpacity * 0.26,
          ),
          AppColors.primaryPink.withValues(
            alpha: effOpacity * 0.075,
          ),
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromCircle(
          center: center,
          radius: radius * 1.65,
        ),
      )
      ..maskFilter = const MaskFilter.blur(
        BlurStyle.normal,
        14,
      );

    canvas.drawCircle(
      center,
      radius * 1.30,
      glowPaint,
    );

    // ------------------------------------------------------------------------
    // RAYS
    // ------------------------------------------------------------------------

    final random = Random(seed);

    for (var i = 0; i < rays; i++) {
      final angle =
          (pi * 2 * i / rays) +
              (random.nextDouble() - 0.5) *
                  0.25;

      final rayLength =
          radius *
              (0.52 +
                  random.nextDouble() * 0.82);

      final innerRadius =
          radius *
              (0.04 +
                  random.nextDouble() * 0.10);

      final start = Offset(
        center.dx +
            cos(angle) * innerRadius,
        center.dy +
            sin(angle) * innerRadius,
      );

      final end = Offset(
        center.dx +
            cos(angle) * rayLength,
        center.dy +
            sin(angle) * rayLength,
      );

      // Soft ray glow.
      final rayGlow = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5.0
        ..strokeCap = StrokeCap.round
        ..color = AppColors.primaryPink.withValues(
          alpha: effOpacity * 0.075,
        )
        ..maskFilter = const MaskFilter.blur(
          BlurStyle.normal,
          5,
        );

      canvas.drawLine(
        start,
        end,
        rayGlow,
      );

      // Main ray.
      final rayPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth =
            random.nextDouble() * 1.05 +
                0.65
        ..strokeCap = StrokeCap.round
        ..color = AppColors.primaryPink.withValues(
          alpha: effOpacity *
              (0.34 +
                  random.nextDouble() *
                      0.46),
        );

      canvas.drawLine(
        start,
        end,
        rayPaint,
      );

      // White hot tip (dimmed slightly)
      final particleRadius =
          random.nextDouble() * 1.25 +
              0.30;

      final particlePaint = Paint()
        ..color = Colors.white.withValues(
          alpha: effOpacity * 0.35,
        );

      canvas.drawCircle(
        end,
        particleRadius,
        particlePaint,
      );
    }

    // ------------------------------------------------------------------------
    // SECONDARY PARTICLES
    // ------------------------------------------------------------------------

    for (var i = 0; i < rays ~/ 2; i++) {
      final angle =
          random.nextDouble() *
              pi *
              2;

      final distance =
          radius *
              (0.72 +
                  random.nextDouble() * 0.82);

      final position = Offset(
        center.dx +
            cos(angle) * distance,
        center.dy +
            sin(angle) * distance,
      );

      final paint = Paint()
        ..color = AppColors.primaryPink.withValues(
          alpha: effOpacity * 0.42,
        );

      canvas.drawCircle(
        position,
        random.nextDouble() *
            1.05 +
            0.3,
        paint,
      );
    }

    // ------------------------------------------------------------------------
    // SECONDARY WHITE PARTICLES (dimmed)
    // ------------------------------------------------------------------------

    for (var i = 0; i < rays ~/ 3; i++) {
      final angle =
          random.nextDouble() * pi * 2;

      final distance =
          radius *
              (0.9 +
                  random.nextDouble() * 0.55);

      final position = Offset(
        center.dx +
            cos(angle) * distance,
        center.dy +
            sin(angle) * distance,
      );

      final paint = Paint()
        ..color = Colors.white.withValues(
          alpha: effOpacity * 0.25,
        );

      canvas.drawCircle(
        position,
        random.nextDouble() * 0.9 + 0.25,
        paint,
      );
    }

    // ------------------------------------------------------------------------
    // WHITE / PINK CORE
    // ------------------------------------------------------------------------

    final corePaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.white.withValues(
            alpha: effOpacity * 0.85,
          ),
          AppColors.primaryPink.withValues(
            alpha: effOpacity * 0.70,
          ),
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromCircle(
          center: center,
          radius: radius * 0.34,
        ),
      );

    canvas.drawCircle(
      center,
      radius * 0.34,
      corePaint,
    );

    // Tiny white-hot center (dimmed)
    final core = Paint()
      ..color = Colors.white.withValues(
        alpha: effOpacity * 0.60,
      );

    canvas.drawCircle(
      center,
      radius * 0.075,
      core,
    );
  }

  // ==========================================================================
  // FOUR POINT SPARKLE (dimmed)
  // ==========================================================================

  void _paintSparkle(
      Canvas canvas,
      Offset center,
      double radius,
      double opacity,
      ) {
    final effOpacity = opacity * _dimFactor;

    // ------------------------------------------------------------------------
    // GLOW
    // ------------------------------------------------------------------------

    final glowPaint = Paint()
      ..color = AppColors.primaryPink.withValues(
        alpha: effOpacity * 0.16,
      )
      ..maskFilter = const MaskFilter.blur(
        BlurStyle.normal,
        8,
      );

    canvas.drawCircle(
      center,
      radius * 0.75,
      glowPaint,
    );

    // ------------------------------------------------------------------------
    // VERTICAL BEAM
    // ------------------------------------------------------------------------

    final verticalRect = Rect.fromCenter(
      center: center,
      width: radius * 0.25,
      height: radius * 3.8,
    );

    final vertical = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.transparent,
          AppColors.primaryPink.withValues(
            alpha: effOpacity * 0.46,
          ),
          Colors.white.withValues(
            alpha: effOpacity * 0.80,
          ),
          AppColors.primaryPink.withValues(
            alpha: effOpacity * 0.46,
          ),
          Colors.transparent,
        ],
      ).createShader(
        verticalRect,
      );

    canvas.drawRect(
      verticalRect,
      vertical,
    );

    // ------------------------------------------------------------------------
    // HORIZONTAL BEAM
    // ------------------------------------------------------------------------

    final horizontalRect = Rect.fromCenter(
      center: center,
      width: radius * 3.8,
      height: radius * 0.25,
    );

    final horizontal = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Colors.transparent,
          AppColors.primaryPink.withValues(
            alpha: effOpacity * 0.44,
          ),
          Colors.white.withValues(
            alpha: effOpacity * 0.78,
          ),
          AppColors.primaryPink.withValues(
            alpha: effOpacity * 0.44,
          ),
          Colors.transparent,
        ],
      ).createShader(
        horizontalRect,
      );

    canvas.drawRect(
      horizontalRect,
      horizontal,
    );

    // ------------------------------------------------------------------------
    // CORE (dimmed)
    // ------------------------------------------------------------------------

    final centerPaint = Paint()
      ..color = Colors.white.withValues(
        alpha: effOpacity * 0.85,
      );

    canvas.drawCircle(
      center,
      radius * 0.18,
      centerPaint,
    );
  }

  // ==========================================================================
  // ORIGIN (dimmed)
  // ==========================================================================

  void _paintOrigin(
      Canvas canvas,
      Offset origin,
      ) {
    final glow = Paint()
      ..color = AppColors.primaryPink.withValues(
        alpha: 0.22 * _dimFactor,
      )
      ..maskFilter = const MaskFilter.blur(
        BlurStyle.normal,
        18,
      );

    canvas.drawCircle(
      origin,
      17,
      glow,
    );

    final core = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.white.withValues(
            alpha: 0.85 * _dimFactor,
          ),
          AppColors.primaryPink.withValues(
            alpha: 0.72 * _dimFactor,
          ),
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromCircle(
          center: origin,
          radius: 10,
        ),
      );

    canvas.drawCircle(
      origin,
      10,
      core,
    );
  }

  // ==========================================================================
  // ATMOSPHERIC GLOW (already has opacity param, now dimmed via _dimFactor)
  // ==========================================================================

  void _paintGlow(
      Canvas canvas,
      Offset center,
      Color color,
      double radius, {
        double opacity = 0.08,
      }) {
    // If it's a pink glow, we dim it; purple stays as is.
    final effectiveOpacity = (color == AppColors.primaryPink)
        ? opacity * _dimFactor
        : opacity;

    final rect = Rect.fromCircle(
      center: center,
      radius: radius,
    );

    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          color.withValues(
            alpha: effectiveOpacity,
          ),
          color.withValues(
            alpha: effectiveOpacity * 0.28,
          ),
          color.withValues(
            alpha: 0,
          ),
        ],
        stops: const [
          0.0,
          0.38,
          1.0,
        ],
      ).createShader(rect)
      ..maskFilter = const MaskFilter.blur(
        BlurStyle.normal,
        48,
      );

    canvas.drawCircle(
      center,
      radius,
      paint,
    );
  }

  // ==========================================================================
  // CENTER PURPLE / PINK MIX (dimmed)
  // ==========================================================================

  void _paintCenterMix(
      Canvas canvas,
      Size size,
      ) {
    final rect = Offset.zero & size;

    final purple = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.7, 0.0),
        radius: 1.0,
        colors: [
          AppColors.liquidPurple.withValues(
            alpha: 0.022,
          ),
          Colors.transparent,
        ],
      ).createShader(rect)
      ..maskFilter = const MaskFilter.blur(
        BlurStyle.normal,
        40,
      );

    canvas.drawRect(
      rect,
      purple,
    );

    final pink = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0.75, 0.05),
        radius: 1.0,
        colors: [
          AppColors.liquidPink.withValues(
            alpha: 0.020 * _dimFactor,
          ),
          Colors.transparent,
        ],
      ).createShader(rect)
      ..maskFilter = const MaskFilter.blur(
        BlurStyle.normal,
        40,
      );

    canvas.drawRect(
      rect,
      pink,
    );
  }

  // ==========================================================================
  // REPAINT
  // ==========================================================================

  @override
  bool shouldRepaint(
      covariant _StarfieldPainter oldDelegate,
      ) {
    return oldDelegate.starCount != starCount;
  }
}

// ============================================================================
// FIREWORK BRANCH MODEL
// ============================================================================

class _FireworkBranch {
  /// Exact location where this branch visually connects to the main trail.
  final Offset anchor;

  /// Location where the branch explodes.
  final Offset end;

  /// Curvature of the branch.
  final double curve;

  /// Branch thickness.
  final double width;

  /// Branch opacity.
  final double opacity;

  /// Explosion size relative to screen width.
  final double burstRadius;

  /// Number of rays in the explosion.
  final int rays;

  /// Random seed.
  final int seed;

  const _FireworkBranch({
    required this.anchor,
    required this.end,
    required this.curve,
    required this.width,
    required this.opacity,
    required this.burstRadius,
    required this.rays,
    required this.seed,
  });
}