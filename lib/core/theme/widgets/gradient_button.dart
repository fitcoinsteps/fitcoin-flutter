import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import '../app_colors.dart';
import '../app_text_styles.dart';

/// Premium dark glass CTA.
///
/// Designed to match the FitCoin StarfieldBackground:
/// - Dark atmospheric glass
/// - Dim purple + pink glows
/// - Curved color mixing
/// - Subtle stars inside the glass
/// - Soft glass reflection
/// - 3D bevel
/// - Hover / pressed interaction
class GradientButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double height;

  const GradientButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.height = 54,
  });

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton> {
  bool _hovered = false;
  bool _pressed = false;

  bool get _disabled =>
      widget.onPressed == null || widget.isLoading;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(widget.height / 2);

    return AnimatedScale(
      scale: _pressed
          ? 0.975
          : (_hovered && !_disabled ? 1.008 : 1.0),
      duration: const Duration(milliseconds: 130),
      curve: Curves.easeOut,
      child: Container(
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: radius,
          boxShadow: _disabled
              ? null
              : [
            // Very soft pink ambient shadow.
            BoxShadow(
              color: AppColors.primaryPink.withValues(
                alpha: _pressed ? 0.10 : 0.18,
              ),
              blurRadius: _pressed ? 14 : 24,
              spreadRadius: -4,
              offset: Offset(
                0,
                _pressed ? 5 : 9,
              ),
            ),

            // Very soft purple ambient shadow.
            BoxShadow(
              color: AppColors.primaryPurple.withValues(
                alpha: _hovered ? 0.16 : 0.09,
              ),
              blurRadius: 22,
              spreadRadius: -5,
              offset: const Offset(-6, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: radius,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // ============================================================
              // DARK GLASS BASE
              // ============================================================

              BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 12,
                  sigmaY: 12,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: radius,
                    color: _disabled
                        ? AppColors.glassFill.withValues(alpha: 0.65)
                        : const Color(0xFF17131F)
                        .withValues(alpha: 0.68),
                  ),
                ),
              ),

              if (!_disabled) ...[
                // ========================================================
                // DIM PURPLE / PINK ATMOSPHERE
                // ========================================================

                Positioned.fill(
                  child: CustomPaint(
                    painter: _DarkLiquidGlassPainter(
                      hovered: _hovered,
                      pressed: _pressed,
                    ),
                  ),
                ),

                // ========================================================
                // VERY SUBTLE TOP GLASS LIGHT
                // ========================================================

                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  height: widget.height * 0.48,
                  child: IgnorePointer(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft:
                          Radius.circular(widget.height / 2),
                          topRight:
                          Radius.circular(widget.height / 2),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white.withValues(alpha: 0.075),
                            Colors.white.withValues(alpha: 0.018),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // ========================================================
                // SPECULAR GLASS STREAK
                // ========================================================

                Positioned(
                  left: widget.height * 0.25,
                  top: widget.height * 0.15,
                  width: widget.height * 1.10,
                  height: widget.height * 0.065,
                  child: Transform.rotate(
                    angle: -0.08,
                    child: ImageFiltered(
                      imageFilter: ImageFilter.blur(
                        sigmaX: 1.3,
                        sigmaY: 1.3,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(100),
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Colors.white.withValues(alpha: 0.16),
                              Colors.white.withValues(alpha: 0.07),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // ========================================================
                // TINY GLASS REFLECTION
                // ========================================================

                Positioned(
                  left: widget.height * 0.34,
                  top: widget.height * 0.10,
                  width: widget.height * 0.07,
                  height: widget.height * 0.07,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withValues(alpha: 0.10),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
                ),

                // ========================================================
                // OUTER GLASS BORDER
                // ========================================================

                Positioned.fill(
                  child: IgnorePointer(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: radius,
                        border: Border.all(
                          color: Colors.white.withValues(
                            alpha: _hovered ? 0.20 : 0.13,
                          ),
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                ),

                // ========================================================
                // INNER DARK BEVEL
                // ========================================================

                Positioned.fill(
                  child: IgnorePointer(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: radius,
                        border: Border.all(
                          color: Colors.black.withValues(alpha: 0.16),
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ],

              // ==========================================================
              // CONTENT / INTERACTION
              // ==========================================================

              MouseRegion(
                cursor: _disabled
                    ? SystemMouseCursors.basic
                    : SystemMouseCursors.click,
                onEnter: (_) {
                  if (!_disabled) {
                    setState(() => _hovered = true);
                  }
                },
                onExit: (_) {
                  if (!_disabled) {
                    setState(() => _hovered = false);
                  }
                },
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,

                  onTapDown: _disabled
                      ? null
                      : (_) {
                    setState(() => _pressed = true);
                  },

                  onTapUp: _disabled
                      ? null
                      : (_) {
                    setState(() => _pressed = false);
                    widget.onPressed?.call();
                  },

                  onTapCancel: _disabled
                      ? null
                      : () {
                    setState(() => _pressed = false);
                  },

                  child: Center(
                    child: widget.isLoading
                        ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.2,
                      ),
                    )
                        : Text(
                      widget.label,
                      style:
                      AppTextStyles.buttonLabel.copyWith(
                        color: Colors.white.withValues(
                          alpha: 0.92,
                        ),
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(
                              alpha: 0.35,
                            ),
                            blurRadius: 5,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
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
// DARK LIQUID GLASS PAINTER
// ============================================================================

class _DarkLiquidGlassPainter extends CustomPainter {
  final bool hovered;
  final bool pressed;

  _DarkLiquidGlassPainter({
    required this.hovered,
    required this.pressed,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    // ========================================================================
    // DARK BASE
    // ========================================================================

    final basePaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Color(0xFF21182D),
          Color(0xFF211725),
          Color(0xFF271622),
        ],
      ).createShader(rect);

    canvas.drawRect(rect, basePaint);

    // ========================================================================
    // PURPLE GLOW — LEFT SIDE
    // Similar to StarfieldBackground.
    // ========================================================================

    final purpleGlow = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-1.05, 0.05),
        radius: 0.95,
        colors: [
          AppColors.primaryPurple.withValues(alpha: 0.25),
          AppColors.primaryPurple.withValues(alpha: 0.11),
          Colors.transparent,
        ],
        stops: const [
          0.0,
          0.38,
          1.0,
        ],
      ).createShader(rect)
      ..maskFilter = const MaskFilter.blur(
        BlurStyle.normal,
        8,
      );

    canvas.drawRect(rect, purpleGlow);

    // ========================================================================
    // PINK GLOW — RIGHT SIDE
    // ========================================================================

    final pinkGlow = Paint()
      ..shader = RadialGradient(
        center: const Alignment(1.05, 0.10),
        radius: 0.95,
        colors: [
          AppColors.primaryPink.withValues(alpha: 0.22),
          AppColors.primaryPink.withValues(alpha: 0.09),
          Colors.transparent,
        ],
        stops: const [
          0.0,
          0.40,
          1.0,
        ],
      ).createShader(rect)
      ..maskFilter = const MaskFilter.blur(
        BlurStyle.normal,
        8,
      );

    canvas.drawRect(rect, pinkGlow);

    // ========================================================================
    // CURVED LIQUID BOUNDARY
    // ========================================================================

    final liquidPath = Path();

    liquidPath.moveTo(
      size.width * 0.57,
      -10,
    );

    liquidPath.cubicTo(
      size.width * 0.45,
      size.height * 0.18,
      size.width * 0.68,
      size.height * 0.30,
      size.width * 0.54,
      size.height * 0.50,
    );

    liquidPath.cubicTo(
      size.width * 0.43,
      size.height * 0.67,
      size.width * 0.66,
      size.height * 0.80,
      size.width * 0.49,
      size.height + 10,
    );

    liquidPath.lineTo(
      size.width + 10,
      size.height + 10,
    );

    liquidPath.lineTo(
      size.width + 10,
      -10,
    );

    liquidPath.close();

    // ========================================================================
    // MUTED PINK LIQUID
    // ========================================================================

    final liquidPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF55213F),
          Color(0xFF662546),
          Color(0xFF7D2855),
        ],
      ).createShader(rect);

    canvas.drawPath(
      liquidPath,
      liquidPaint,
    );

    // ========================================================================
    // SOFT PURPLE / PINK MIXING
    // ========================================================================

    final mixPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Colors.transparent,
          AppColors.primaryPink.withValues(alpha: 0.075),
          Colors.transparent,
        ],
      ).createShader(rect)
      ..maskFilter = const MaskFilter.blur(
        BlurStyle.normal,
        14,
      );

    final mixPath = Path();

    mixPath.moveTo(
      size.width * 0.57,
      -5,
    );

    mixPath.cubicTo(
      size.width * 0.45,
      size.height * 0.18,
      size.width * 0.68,
      size.height * 0.30,
      size.width * 0.54,
      size.height * 0.50,
    );

    mixPath.cubicTo(
      size.width * 0.43,
      size.height * 0.67,
      size.width * 0.66,
      size.height * 0.80,
      size.width * 0.49,
      size.height + 5,
    );

    canvas.drawPath(
      mixPath,
      mixPaint,
    );

    // ========================================================================
    // DIM CENTER ATMOSPHERE
    // ========================================================================

    final centerGlow = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0.0, 0.0),
        radius: 0.8,
        colors: [
          Colors.white.withValues(alpha: 0.018),
          Colors.transparent,
        ],
      ).createShader(rect);

    canvas.drawRect(
      rect,
      centerGlow,
    );

    // ========================================================================
    // STAR / PARTICLE DETAILS
    // ========================================================================
    //
    // Same idea as your StarfieldBackground, but much more subtle because
    // this is inside the glass.

    final random = Random(19);

    for (var i = 0; i < 18; i++) {
      final dx = random.nextDouble() * size.width;
      final dy = random.nextDouble() * size.height;

      final radius = random.nextDouble() * 0.65 + 0.2;

      final opacity = random.nextDouble() * 0.13 + 0.035;

      final starPaint = Paint()
        ..color = Colors.white.withValues(
          alpha: opacity,
        );

      canvas.drawCircle(
        Offset(dx, dy),
        radius,
        starPaint,
      );
    }

    // ========================================================================
    // SUBTLE HOVER ATMOSPHERE
    // ========================================================================

    if (hovered && !pressed) {
      final hoverPaint = Paint()
        ..shader = RadialGradient(
          center: const Alignment(0, -1),
          radius: 1.1,
          colors: [
            Colors.white.withValues(alpha: 0.035),
            Colors.transparent,
          ],
        ).createShader(rect);

      canvas.drawRect(
        rect,
        hoverPaint,
      );
    }

    // ========================================================================
    // PRESSED STATE
    // ========================================================================

    if (pressed) {
      final pressedPaint = Paint()
        ..color = Colors.black.withValues(alpha: 0.12);

      canvas.drawRect(
        rect,
        pressedPaint,
      );
    }

    // ========================================================================
    // BOTTOM EDGE DARKNESS
    // ========================================================================

    final bottomPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.transparent,
          Colors.black.withValues(alpha: 0.12),
        ],
      ).createShader(rect);

    canvas.drawRect(
      rect,
      bottomPaint,
    );
  }

  @override
  bool shouldRepaint(
      covariant _DarkLiquidGlassPainter oldDelegate,
      ) {
    return oldDelegate.hovered != hovered ||
        oldDelegate.pressed != pressed;
  }
}