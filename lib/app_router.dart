import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'features/auth/presentation/screens/register_screen.dart';
import 'features/auth/presentation/screens/verify_otp_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/register',
  routes: [
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
      path: '/home',
      builder: (context, state) => const Placeholder(),
    ),
  ],
);