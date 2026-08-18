import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fitcoin/core/theme/app_colors.dart';
import 'package:fitcoin/core/theme/app_text_styles.dart';
import 'package:fitcoin/core/theme/widgets/starfield_background.dart';
import 'package:fitcoin/core/theme/widgets/glass_card.dart';
import 'package:fitcoin/core/theme/widgets/gradient_button.dart';
import 'package:fitcoin/features/forgot_password/presentation/providers/forgot_password_providers.dart';

class VerifyResetOtpScreen extends ConsumerStatefulWidget {
  final String email;

  const VerifyResetOtpScreen({super.key, required this.email});

  @override
  ConsumerState<VerifyResetOtpScreen> createState() =>
      _VerifyResetOtpScreenState();
}

class _VerifyResetOtpScreenState extends ConsumerState<VerifyResetOtpScreen> {
  final _otpController = TextEditingController();
  final _otpFocus = FocusNode();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _otpFocus.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _otpController.dispose();
    _otpFocus.dispose();
    super.dispose();
  }

  void _verifyOtp() async {
    if (_otpController.text.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid 6-digit OTP')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final result = await ref
        .read(forgotPasswordRepositoryProvider)
        .verifyResetOtp(email: widget.email, code: _otpController.text);

    if (!mounted) return;

    result.fold(
          (failure) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(failure.message)),
        );
      },
          (token) {
        setState(() => _isLoading = false);
        context.push(
          '/reset-password',
          extra: {'email': widget.email, 'token': token},
        );
      },
    );
  }

  // ===========================================================================
  // INPUT FIELD – same style as Login/Register
  // ===========================================================================

  Widget _buildOtpField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String hint,
  }) {
    final hasFocus = focusNode.hasFocus;

    final Color activePink =
    AppColors.primaryPink.withValues(alpha: 0.55);
    final Color softPink =
    AppColors.primaryPink.withValues(alpha: 0.24);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: hasFocus
            ? [
          BoxShadow(
            color: AppColors.primaryPink.withValues(alpha: 0.12),
            blurRadius: 14,
            spreadRadius: 1,
          ),
        ]
            : null,
      ),
      child: CustomPaint(
        painter: _RandomCornerBorderPainter(
          color: hasFocus ? activePink : softPink,
          glowColor: AppColors.primaryPink.withValues(
            alpha: hasFocus ? 0.20 : 0.09,
          ),
          strokeWidth: hasFocus ? 1.35 : 1.0,
          radius: 16,
        ),
        child: GlassCard(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          borderRadius: 16,
          borderColor: Colors.transparent,
          child: TextFormField(
            controller: controller,
            focusNode: focusNode,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 6,
            style: AppTextStyles.inputText,
            cursorColor: AppColors.primaryPink,
            decoration: InputDecoration(
              isDense: true,
              filled: false,
              counterText: '', // hide the counter
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
              hintText: hasFocus ? null : hint,
              hintStyle: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
              prefixIcon: Icon(
                Icons.pin_outlined,
                color: AppColors.primaryPink.withValues(alpha: 0.72),
                size: 20,
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // BUILD
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    // Logo glow & border (same as other screens)
    final glowColor = AppColors.primaryPink.withValues(alpha: 0.24);
    final borderColor = AppColors.primaryPink.withValues(alpha: 0.42);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: StarfieldBackground(
        child: Center(
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 12),

                  // =========================================================
                  // LOGO – asset image (circular with pink glow)
                  // =========================================================
                  Center(
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: glowColor,
                            blurRadius: 25,
                            spreadRadius: 8,
                          ),
                        ],
                        border: Border.all(
                          color: borderColor,
                          width: 3,
                        ),
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/Logo.jpeg', // update to your path
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // =========================================================
                  // HEADING & SUBTITLE
                  // =========================================================
                  Text(
                    'Verify OTP',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.heading,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Enter the 6-digit OTP sent to',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.subheading,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.email,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryPink,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // =========================================================
                  // OTP FIELD
                  // =========================================================
                  _buildOtpField(
                    controller: _otpController,
                    focusNode: _otpFocus,
                    hint: 'Enter 6-digit OTP',
                  ),
                  const SizedBox(height: 20),

                  // =========================================================
                  // VERIFY BUTTON
                  // =========================================================
                  GradientButton(
                    label: 'Verify & Continue',
                    isLoading: _isLoading,
                    onPressed: _isLoading ? null : _verifyOtp,
                  ),
                  const SizedBox(height: 20),

                  // =========================================================
                  // BACK TO LOGIN
                  // =========================================================
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Remember your password?",
                        style: AppTextStyles.subheading,
                      ),
                      TextButton(
                        onPressed: () => context.go('/login'),
                        child: const Text(
                          'Login',
                          style: AppTextStyles.linkText,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// RANDOM CORNER BORDER PAINTER – same as Login/Register
// ============================================================================

class _RandomCornerBorderPainter extends CustomPainter {
  final Color color;
  final Color glowColor;
  final double strokeWidth;
  final double radius;

  const _RandomCornerBorderPainter({
    required this.color,
    required this.glowColor,
    required this.strokeWidth,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = color;

    final glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth + 3
      ..strokeCap = StrokeCap.round
      ..color = glowColor
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);

    // Top-left
    final topLeft = Path()
      ..moveTo(5, radius)
      ..quadraticBezierTo(5, 5, radius, 5);

    // Top-right
    final topRight = Path()
      ..moveTo(size.width - radius, 5)
      ..quadraticBezierTo(size.width - 5, 5, size.width - 5, radius);

    // Bottom-left
    final bottomLeft = Path()
      ..moveTo(5, size.height - radius)
      ..quadraticBezierTo(5, size.height - 5, radius, size.height - 5);

    // Bottom-right
    final bottomRight = Path()
      ..moveTo(size.width - radius, size.height - 5)
      ..quadraticBezierTo(size.width - 5, size.height - 5, size.width - 5, size.height - radius);

    // Highlight top-left & bottom-right
    final paths = [topLeft, bottomRight];

    for (final path in paths) {
      canvas.drawPath(path, glowPaint);
      canvas.drawPath(path, paint);
    }

    // Extra fragments
    final fragmentPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = color.withValues(alpha: 0.65);

    final fragmentGlow = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth + 2
      ..strokeCap = StrokeCap.round
      ..color = glowColor.withValues(alpha: 0.65)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    final topRightFragment = Path()
      ..moveTo(size.width - radius - 8, 5)
      ..lineTo(size.width - radius + 7, 5);

    final bottomLeftFragment = Path()
      ..moveTo(5, size.height - radius - 7)
      ..lineTo(5, size.height - radius + 6);

    canvas.drawPath(topRightFragment, fragmentGlow);
    canvas.drawPath(topRightFragment, fragmentPaint);
    canvas.drawPath(bottomLeftFragment, fragmentGlow);
    canvas.drawPath(bottomLeftFragment, fragmentPaint);
  }

  @override
  bool shouldRepaint(covariant _RandomCornerBorderPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.glowColor != glowColor ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.radius != radius;
  }
}