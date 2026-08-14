import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class BackgroundWidget extends StatelessWidget {
  const BackgroundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0, -0.4),
                radius: 1.25,
                colors: [AppColors.bgDeep2, AppColors.bgDeep],
              ),
            ),
          ),

          Positioned(
            top: -70,
            left: -70,
            child: _GlowBlob(
              color: AppColors.pinkPrimary.withValues(alpha: 0.28),
              size: 260,
            ),
          ),
          Positioned(
            top: 120,
            right: -100,
            child: _GlowBlob(
              color: AppColors.purpleAccent.withValues(alpha: 0.22),
              size: 260,
            ),
          ),
          Positioned(
            bottom: -60,
            left: -40,
            child: _GlowBlob(
              color: AppColors.blueAccent.withValues(alpha: 0.16),
              size: 220,
            ),
          ),

          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(painter: _WaveSparklePainter()),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlowBlob extends StatelessWidget {
  final Color color;
  final double size;

  const _GlowBlob({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [color, color.withValues(alpha: 0)]),
      ),
    );
  }
}

class _WaveSparklePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    path.moveTo(-40, size.height * 0.85);
    path.cubicTo(
      size.width * 0.35,
      size.height * 0.05,
      size.width * 0.7,
      size.height * 0.45,
      size.width * 1.15,
      size.height * 0.10,
    );

    final outerGlowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 55.0
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 25)
      ..shader = LinearGradient(
        colors: [
          AppColors.pinkPrimary.withValues(alpha: 0.0),
          AppColors.pinkPrimary.withValues(alpha: 0.6),
          AppColors.purpleAccent.withValues(alpha: 0.4),
          AppColors.pinkPrimary.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawPath(path, outerGlowPaint);

    final corePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 25.0
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8)
      ..shader = LinearGradient(
        colors: [
          AppColors.pinkPrimary.withValues(alpha: 0.4),
          AppColors.pinkPrimary,
          AppColors.purpleAccent,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawPath(path, corePaint);

    final highlightPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round
      ..color = Colors.white.withValues(alpha: 0.3);
    canvas.drawPath(path, highlightPaint);

    final sparklePaint = Paint()
      ..color = AppColors.pinkPrimary.withValues(alpha: 0.9)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    final crossPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.6)
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    final sparklePositions = [
      Offset(size.width * 0.10, size.height * 0.70),
      Offset(size.width * 0.25, size.height * 0.40),
      Offset(size.width * 0.35, size.height * 0.15),
      Offset(size.width * 0.45, size.height * 0.35),
      Offset(size.width * 0.55, size.height * 0.55),
      Offset(size.width * 0.65, size.height * 0.25),
      Offset(size.width * 0.75, size.height * 0.45),
      Offset(size.width * 0.85, size.height * 0.15),
      Offset(size.width * 0.95, size.height * 0.05),
    ];

    for (var pos in sparklePositions) {
      canvas.drawCircle(pos, 4.0, sparklePaint);
      canvas.drawLine(
        Offset(pos.dx - 6, pos.dy),
        Offset(pos.dx + 6, pos.dy),
        crossPaint,
      );
      canvas.drawLine(
        Offset(pos.dx, pos.dy - 6),
        Offset(pos.dx, pos.dy + 6),
        crossPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
