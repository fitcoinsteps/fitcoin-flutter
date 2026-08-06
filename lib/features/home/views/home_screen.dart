import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widget/glass_bottom_nav.dart';
import '../../../shared/widget/background_widget.dart';
import '../../../shared/widget/global_app_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _navIndex = 0;

  static const double _stepsPercent = 0.7125;
  static const int _steps = 14250;
  static const String _dateLabel = 'Wednesday, November 15';
  static const String _userName = 'Sarah';
  static const String _tokenBalance = '1,250 FC';

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    const appBarHeight = kToolbarHeight;

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          const BackgroundWidget(),

          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: EdgeInsets.fromLTRB(
                  22,
                  statusBarHeight + appBarHeight + 8,
                  22,
                  130,
                ),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    RepaintBoundary(
                          child: StepsRing(
                            percent: _stepsPercent,
                            steps: _steps,
                            date: _dateLabel,
                          ),
                        )
                        .animate()
                        .fadeIn(duration: 550.ms, curve: Curves.easeOut)
                        .scale(
                          begin: const Offset(0.88, 0.88),
                          end: const Offset(1, 1),
                          duration: 550.ms,
                          curve: Curves.easeOutBack,
                        ),
                    const SizedBox(height: 32),
                    _FeatureGrid(
                          onTapCard: (label) => _onCardTap(context, label),
                        )
                        .animate()
                        .fadeIn(duration: 500.ms, delay: 150.ms)
                        .slideY(
                          begin: 0.08,
                          end: 0,
                          duration: 500.ms,
                          delay: 150.ms,
                          curve: Curves.easeOutCubic,
                        ),
                  ]),
                ),
              ),
            ],
          ),

          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: GlobalAppBar(
              leading: _AvatarBadge(),

              titleWidget: _GreetingHeader(userName: _userName),

              actions: [_TokenBalance(balance: _tokenBalance)],
            ),
          ),

          Positioned(
            left: 22,
            right: 22,
            bottom: 22,
            child: GlassBottomNav(
              currentIndex: _navIndex,
              onTap: (i) => setState(() => _navIndex = i),
            ),
          ),
        ],
      ),
    );
  }

  void _onCardTap(BuildContext context, String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.cardBg,
        content: Text(
          '$label tapped',
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

class _GreetingHeader extends StatelessWidget {
  final String userName;

  const _GreetingHeader({required this.userName});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Good Morning,',
          style: GoogleFonts.poppins(
            color: AppColors.textLavender,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          '$userName!',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _AvatarBadge extends StatelessWidget {
  _AvatarBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.pinkPrimary.withOpacity(0.65),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.pinkPrimary.withOpacity(0.45),
            blurRadius: 16,
            spreadRadius: 1,
          ),
        ],
      ),
      child: ClipOval(
        child: Container(
          color: AppColors.cardBg,
          alignment: Alignment.center,
          child: const Icon(
            LucideIcons.user,
            color: AppColors.pinkBright,
            size: 20,
          ),
        ),
      ),
    );
  }
}

class _TokenBalance extends StatelessWidget {
  final String balance;

  const _TokenBalance({required this.balance});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(LucideIcons.coins, color: AppColors.pinkBright, size: 18),
        const SizedBox(width: 6),
        Text(
          balance,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }
}

class StepsRing extends StatefulWidget {
  final double percent;
  final int steps;
  final String date;

  const StepsRing({
    super.key,
    required this.percent,
    required this.steps,
    required this.date,
  });

  @override
  State<StepsRing> createState() => _StepsRingState();
}

class _StepsRingState extends State<StepsRing>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _progress;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _progress = Tween<double>(
      begin: 0,
      end: widget.percent,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _progress,
      builder: (context, child) {
        return SizedBox(
          width: 300,
          height: 300,
          child: CustomPaint(
            painter: _RingPainter(progress: _progress.value),
            child: child,
          ),
        );
      },
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${(widget.percent * 100).toStringAsFixed(2)}%',
              style: GoogleFonts.poppins(
                color: AppColors.pinkBright,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.4,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _formatSteps(widget.steps),
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 50,
                fontWeight: FontWeight.w800,
                height: 1.0,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'STEPS',
              style: GoogleFonts.poppins(
                color: AppColors.textLavender,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 3,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              widget.date,
              style: GoogleFonts.poppins(
                color: AppColors.textLavender.withOpacity(0.85),
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatSteps(int steps) {
    final digits = steps.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      final remaining = digits.length - i;
      buffer.write(digits[i]);
      if (remaining > 1 && remaining % 3 == 1) buffer.write(',');
    }
    return buffer.toString();
  }
}

class _RingPainter extends CustomPainter {
  final double progress;

  _RingPainter({required this.progress});

  static const _ringGradientColors = [
    AppColors.blueAccent,
    AppColors.pinkPrimary,
    AppColors.pinkBright,
    AppColors.purpleAccent,
    AppColors.blueAccent,
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (size.shortestSide - 26) / 2;
    const strokeWidth = 18.0;
    final sweepAngle = 2 * math.pi * progress.clamp(0.0, 1.0);
    final arcRect = Rect.fromCircle(center: center, radius: radius);

    final track = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = Colors.white.withOpacity(0.06);
    canvas.drawCircle(center, radius, track);

    final glow = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth + 16
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12)
      ..shader = const SweepGradient(
        colors: _ringGradientColors,
      ).createShader(arcRect);
    canvas.drawArc(arcRect, -math.pi / 2, sweepAngle, false, glow);

    final ring = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..shader = const SweepGradient(
        colors: _ringGradientColors,
      ).createShader(arcRect);
    canvas.drawArc(arcRect, -math.pi / 2, sweepAngle, false, ring);

    final endAngle = -math.pi / 2 + sweepAngle;
    final dotCenter = Offset(
      center.dx + radius * math.cos(endAngle),
      center.dy + radius * math.sin(endAngle),
    );
    canvas.drawCircle(
      dotCenter,
      strokeWidth / 2.2,
      Paint()
        ..color = Colors.white
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class _FeatureGrid extends StatelessWidget {
  final ValueChanged<String> onTapCard;

  const _FeatureGrid({required this.onTapCard});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 0.9,
      children: [
        FeatureCard(
          icon: LucideIcons.footprints,
          title: 'Double Steps',
          subtitle: "Watch ads",
          actionIcon: LucideIcons.play,
          onTap: () => onTapCard('Double Steps'),
        ),
        FeatureCard(
          icon: LucideIcons.coins,
          title: 'Earn Coins',
          subtitle: 'Daily Quests',
          actionIcon: LucideIcons.target,
          onTap: () => onTapCard('Earn Coins'),
        ),
        FeatureCard(
          icon: LucideIcons.banknote,
          title: 'Redeem Cash',
          subtitle: 'Withdraw securely!',
          actionIcon: LucideIcons.wallet,
          onTap: () => onTapCard('Redeem Cash'),
        ),
        FeatureCard(
          icon: LucideIcons.userPlus,
          title: 'Invite',
          subtitle: 'Invite friends!',
          actionIcon: LucideIcons.userPlus,
          onTap: () => onTapCard('Profile & Invite'),
        ),
      ],
    );
  }
}

class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final IconData actionIcon;
  final VoidCallback? onTap;

  const FeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.actionIcon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        splashColor: AppColors.pinkPrimary.withOpacity(0.12),
        highlightColor: AppColors.pinkPrimary.withOpacity(0.06),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.cardBg.withOpacity(0.9),
                AppColors.cardBg.withOpacity(0.55),
              ],
            ),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
            boxShadow: [
              BoxShadow(
                color: AppColors.pinkPrimary.withOpacity(0.10),
                blurRadius: 24,
                spreadRadius: -8,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                color: AppColors.pinkBright,
                size: 32,
                shadows: [
                  Shadow(
                    color: AppColors.pinkPrimary.withOpacity(0.85),
                    blurRadius: 18,
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                title,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: GoogleFonts.poppins(
                  color: AppColors.textLavender,
                  fontSize: 12,
                  height: 1.35,
                ),
              ),
              const Spacer(),
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.06),
                    border: Border.all(
                      color: AppColors.pinkPrimary.withOpacity(0.45),
                    ),
                  ),
                  child: Icon(
                    actionIcon,
                    color: AppColors.pinkBright,
                    size: 16,
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
