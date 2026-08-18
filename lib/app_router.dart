import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'features/auth/presentation/screens/register_screen.dart';
import 'features/auth/presentation/screens/verify_otp_screen.dart';
import 'features/login_auth/presentation/screens/login_screen.dart';
import 'features/main/presentation/screens/main_screen.dart';
import 'features/forgot_password/presentation/screens/forgot_password_screen.dart';
import 'features/forgot_password/presentation/screens/verify_reset_otp_screen.dart';
import 'features/reset_password/presentation/screens/reset_password_screen.dart';
import 'features/step_counter/presentation/screens/step_dashboard_screen.dart';
import 'features/live_tracking/presentation/screens/tracking_screen.dart';
import 'features/fitcoin/presentation/screens/fitcoin_screen.dart';   // ✅ added

final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/verify-otp',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;

        return VerifyOtpScreen(
          email: extra?['email'] ?? '',
          redirect: extra?['redirect'] ?? '/verify-otp',
        );
      },
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: '/verify-reset-otp',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;

        return VerifyResetOtpScreen(
          email: extra?['email'] ?? '',
        );
      },
    ),
    GoRoute(
      path: '/reset-password',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;

        return ResetPasswordScreen(
          email: extra?['email'] ?? '',
          token: extra?['token'] ?? '',
        );
      },
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => const MainScreen(),
    ),
    GoRoute(
      path: '/step-dashboard',
      builder: (context, state) => const StepDashboardScreen(),
    ),
    GoRoute(
      path: '/tracking',
      builder: (context, state) => const TrackingScreen(),
    ),
    GoRoute(
      path: '/fitcoin',
      builder: (context, state) => const FitcoinScreen(),   // ✅ added
    ),
  ],
);