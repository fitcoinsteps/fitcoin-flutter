import 'dart:ui';
import 'package:flutter/material.dart';
import '../app_colors.dart';

/// Shared glassmorphic surface used across the app.
///
/// Features:
/// - Translucent glass fill
/// - Background blur
/// - Soft neutral glass border
/// - Optional pink glow
/// - Optional selective pink corner accents
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final Color? borderColor;

  /// Adds a soft pink atmospheric glow around the card.
  final bool pinkGlow;

  /// Draws pink accents only on selected corners.
  final bool pinkCorners;

  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.borderRadius = 24,
    this.borderColor,
    this.pinkGlow = false,
    this.pinkCorners = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBorderColor =
        borderColor ?? AppColors.glassBorder;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),

        // ------------------------------------------------------------
        // SOFT PINK OUTER GLOW
        // ------------------------------------------------------------
        boxShadow: pinkGlow
            ? [
          BoxShadow(
            color: AppColors.primaryPink.withOpacity(0.12),
            blurRadius: 18,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: AppColors.primaryPurple.withOpacity(0.06),
            blurRadius: 30,
            spreadRadius: 2,
          ),
        ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 18,
            sigmaY: 18,
          ),
          child: Stack(
            children: [
              // ========================================================
              // GLASS BODY
              // ========================================================

              Container(
                padding: padding,
                decoration: BoxDecoration(
                  color: AppColors.glassFill,
                  borderRadius: BorderRadius.circular(borderRadius),
                  border: Border.all(
                    color: effectiveBorderColor,
                    width: 1,
                  ),
                ),
                child: child,
              ),

              // ========================================================
              // SELECTIVE PINK CORNERS
              // ========================================================

              if (pinkCorners)
                Positioned.fill(
                  child: IgnorePointer(
                    child: CustomPaint(
                      painter: _GlassCornerPainter(
                        color: AppColors.primaryPink,
                        borderRadius: borderRadius,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// SELECTIVE CORNER PAINTER
// ============================================================================

class _GlassCornerPainter extends CustomPainter {
  final Color color;
  final double borderRadius;

  const _GlassCornerPainter({
    required this.color,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // ------------------------------------------------------------
    // Pink corner glow
    // ------------------------------------------------------------

    final glowPaint = Paint()
      ..color = color.withOpacity(0.22)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(
        BlurStyle.normal,
        5,
      );

    // ------------------------------------------------------------
    // Sharp pink accent
    // ------------------------------------------------------------

    final accentPaint = Paint()
      ..color = color.withOpacity(0.70)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.35
      ..strokeCap = StrokeCap.round;

    // ============================================================
    // TOP-LEFT
    // ============================================================

    final topLeft = Path();

    topLeft.moveTo(
      0,
      borderRadius + 8,
    );

    topLeft.lineTo(
      0,
      borderRadius * 0.42,
    );

    topLeft.quadraticBezierTo(
      0,
      0,
      borderRadius * 0.42,
      0,
    );

    topLeft.lineTo(
      borderRadius + 8,
      0,
    );

    canvas.drawPath(topLeft, glowPaint);
    canvas.drawPath(topLeft, accentPaint);

    // ============================================================
    // TOP-RIGHT
    // ============================================================

    final topRight = Path();

    topRight.moveTo(
      size.width - borderRadius - 18,
      0,
    );

    topRight.lineTo(
      size.width - borderRadius * 0.42,
      0,
    );

    topRight.quadraticBezierTo(
      size.width,
      0,
      size.width,
      borderRadius * 0.42,
    );

    topRight.lineTo(
      size.width,
      borderRadius + 10,
    );

    canvas.drawPath(topRight, glowPaint);
    canvas.drawPath(topRight, accentPaint);

    // ============================================================
    // BOTTOM-RIGHT
    // ============================================================

    final bottomRight = Path();

    bottomRight.moveTo(
      size.width,
      size.height - borderRadius - 7,
    );

    bottomRight.lineTo(
      size.width,
      size.height - borderRadius * 0.42,
    );

    bottomRight.quadraticBezierTo(
      size.width,
      size.height,
      size.width - borderRadius * 0.42,
      size.height,
    );

    bottomRight.lineTo(
      size.width - borderRadius - 14,
      size.height,
    );

    canvas.drawPath(bottomRight, glowPaint);
    canvas.drawPath(bottomRight, accentPaint);

    // ============================================================
    // BOTTOM-LEFT
    // ============================================================

    final bottomLeft = Path();

    bottomLeft.moveTo(
      borderRadius + 5,
      size.height,
    );

    bottomLeft.lineTo(
      borderRadius * 0.42,
      size.height,
    );

    bottomLeft.quadraticBezierTo(
      0,
      size.height,
      0,
      size.height - borderRadius * 0.42,
    );

    bottomLeft.lineTo(
      0,
      size.height - borderRadius - 8,
    );

    canvas.drawPath(bottomLeft, glowPaint);
    canvas.drawPath(bottomLeft, accentPaint);
  }

  @override
  bool shouldRepaint(
      covariant _GlassCornerPainter oldDelegate,
      ) {
    return oldDelegate.color != color ||
        oldDelegate.borderRadius != borderRadius;
  }
}