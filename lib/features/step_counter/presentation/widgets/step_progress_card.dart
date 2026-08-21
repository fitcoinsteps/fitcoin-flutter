import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:fitcoin/core/theme/app_colors.dart';
import 'package:fitcoin/features/step_counter/domain/entities/step_data.dart';

class StepProgressCard extends StatefulWidget {
  final StepData stepData;
  final bool isSyncing;

  const StepProgressCard({
    super.key,
    required this.stepData,
    this.isSyncing = false,
  });

  @override
  State<StepProgressCard> createState() => _StepProgressCardState();
}

class _StepProgressCardState extends State<StepProgressCard>
    with TickerProviderStateMixin {
  late final AnimationController _progressController;
  late final Animation<double> _progressAnimation;
  late final AnimationController _pulseController;

  double get _targetProgress => widget.stepData.progress.clamp(0.0, 1.0);

  @override
  void initState() {
    super.initState();

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _progressAnimation = CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeOutCubic,
    );

    // Slow, subtle breathing glow — a small sign of life, not a distraction.
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    _progressController.forward();
  }

  @override
  void didUpdateWidget(covariant StepProgressCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.stepData.progress != widget.stepData.progress) {
      _progressController
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _progressController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double progress = _targetProgress;
    final bool isComplete = progress >= 1.0;

    // Derive soft/vibrant pink shades from the app's own accent color, so the
    // ring always stays on-brand even if AppColors.primaryPink changes.
    final HSLColor baseHsl = HSLColor.fromColor(AppColors.primaryPink);
    final Color softPink = baseHsl
        .withLightness((baseHsl.lightness + 0.16).clamp(0.0, 1.0))
        .withSaturation((baseHsl.saturation - 0.05).clamp(0.0, 1.0))
        .toColor();
    final Color vibrantPink = baseHsl
        .withLightness((baseHsl.lightness - 0.05).clamp(0.0, 1.0))
        .withSaturation((baseHsl.saturation + 0.15).clamp(0.0, 1.0))
        .toColor();
    const Color gold = Color(0xFFFFD93D);

    return Center(
      child: SizedBox(
        width: 280,
        height: 280,
        child: AnimatedBuilder(
          animation: Listenable.merge([_progressAnimation, _pulseController]),
          builder: (context, _) {
            final double animatedProgress =
                progress * _progressAnimation.value;
            final double pulse = _pulseController.value;

            return Stack(
              fit: StackFit.expand,
              alignment: Alignment.center,
              children: [
                // Track + gradient progress arc + glowing tip, all in one painter.
                CustomPaint(
                  painter: _StepRingPainter(
                    progress: animatedProgress,
                    pulse: pulse,
                    trackColor: Colors.white.withOpacity(0.06),
                    softPink: softPink,
                    vibrantPink: vibrantPink,
                  ),
                ),

                // Center content - dark, softly lit sphere sitting inside the ring.
                Container(
                  margin: const EdgeInsets.all(22),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const RadialGradient(
                      center: Alignment(-0.3, -0.4),
                      radius: 1.1,
                      colors: [Color(0xFF1A1A1A), Color(0xFF0A0A0A)],
                    ),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.06),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Eyebrow label with icon - NO BACKGROUND
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.directions_walk,
                            color: AppColors.primaryPink, // Pink icon
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'STEPS TODAY',
                            style: TextStyle(
                              color: AppColors.primaryPink, // Pink text
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.4,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Step count — Pink hero number
                      Text(
                        '${widget.stepData.steps}',
                        style: TextStyle(
                          color: AppColors.primaryPink, // Pink color
                          fontSize: 44,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                          height: 1.0,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Goal / achieved state - White color
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: EdgeInsets.symmetric(
                          horizontal: isComplete ? 10 : 0,
                          vertical: isComplete ? 4 : 0,
                        ),
                        decoration: BoxDecoration(
                          color: isComplete
                              ? gold.withOpacity(0.12)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.emoji_events,
                              color: isComplete
                                  ? gold
                                  : Colors.white.withOpacity(0.7), // White icon
                              size: 15,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              isComplete
                                  ? 'Goal Achieved'
                                  : 'Goal: ${widget.stepData.goal}',
                              style: TextStyle(
                                color: isComplete
                                    ? gold
                                    : Colors.white.withOpacity(0.8), // White text
                                fontSize: 12.5,
                                fontWeight:
                                isComplete ? FontWeight.w700 : FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Slim gradient progress bar
                      SizedBox(
                        width: 128,
                        height: 3,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(3),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Container(color: Colors.white.withOpacity(0.08)),
                              FractionallySizedBox(
                                alignment: Alignment.centerLeft,
                                widthFactor: animatedProgress.clamp(0.0, 1.0),
                                heightFactor: 1.0,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [softPink, vibrantPink],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 7),

                      // Percentage — Pink color
                      Text(
                        '${(progress * 100).toStringAsFixed(0)}%',
                        style: TextStyle(
                          color: AppColors.primaryPink, // Pink color
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),

                // Syncing indicator
                if (widget.isSyncing)
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF0D0D0D).withOpacity(0.9),
                        border: Border.all(
                          color: vibrantPink.withOpacity(0.35),
                          width: 1,
                        ),
                      ),
                      child: SizedBox(
                        width: 12,
                        height: 12,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(vibrantPink),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Paints the track, the gradient progress arc, its soft glow, and a small
/// glowing "knob" that marks exactly where progress currently sits.
class _StepRingPainter extends CustomPainter {
  final double progress; // 0..1, already includes entrance-animation value
  final double pulse; // 0..1, drives the breathing glow
  final Color trackColor;
  final Color softPink;
  final Color vibrantPink;

  static const double strokeWidth = 12;

  _StepRingPainter({
    required this.progress,
    required this.pulse,
    required this.trackColor,
    required this.softPink,
    required this.vibrantPink,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = size.center(Offset.zero);
    final double radius = (size.shortestSide - strokeWidth) / 2;
    final Rect rect = Rect.fromCircle(center: center, radius: radius);
    const double startAngle = -math.pi / 2; // 12 o'clock
    final double sweepAngle = 2 * math.pi * progress;

    // Background track
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = trackColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round,
    );

    if (progress <= 0.001) return;

    // Soft ambient glow directly under the progress arc
    canvas.drawArc(
      rect,
      startAngle,
      sweepAngle,
      false,
      Paint()
        ..color = vibrantPink.withOpacity(0.30 + pulse * 0.12)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth + 10
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
    );

    // Gradient progress arc (soft pink -> vibrant pink, in the direction of travel)
    final Shader gradientShader = SweepGradient(
      startAngle: startAngle,
      endAngle: startAngle + 2 * math.pi,
      colors: [softPink, vibrantPink],
    ).createShader(rect);

    canvas.drawArc(
      rect,
      startAngle,
      sweepAngle,
      false,
      Paint()
        ..shader = gradientShader
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round,
    );

    // Glowing knob at the tip — makes "today's current step" unmistakable
    final double tipAngle = startAngle + sweepAngle;
    final Offset tip = Offset(
      center.dx + radius * math.cos(tipAngle),
      center.dy + radius * math.sin(tipAngle),
    );

    canvas.drawCircle(
      tip,
      strokeWidth * 0.85 + pulse * 2.5,
      Paint()
        ..color = vibrantPink.withOpacity(0.32)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );
    canvas.drawCircle(tip, strokeWidth * 0.4, Paint()..color = Colors.white);
    canvas.drawCircle(
      tip,
      strokeWidth * 0.4,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = vibrantPink,
    );
  }

  @override
  bool shouldRepaint(covariant _StepRingPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.pulse != pulse;
  }
}