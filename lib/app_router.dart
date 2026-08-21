import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:fitcoin/features/auth/presentation/screens/register_screen.dart';
import 'package:fitcoin/features/auth/presentation/screens/verify_otp_screen.dart';
import 'package:fitcoin/features/login_auth/presentation/screens/login_screen.dart';
import 'package:fitcoin/features/main/presentation/screens/main_screen.dart';
import 'package:fitcoin/features/forgot_password/presentation/screens/forgot_password_screen.dart';
import 'package:fitcoin/features/forgot_password/presentation/screens/verify_reset_otp_screen.dart';
import 'package:fitcoin/features/reset_password/presentation/screens/reset_password_screen.dart';
import 'package:fitcoin/features/step_counter/presentation/screens/step_dashboard_screen.dart';
import 'package:fitcoin/features/live_tracking/presentation/screens/tracking_screen.dart';
import 'package:fitcoin/features/fitcoin/presentation/screens/fitcoin_screen.dart';
import 'package:fitcoin/features/friends/presentation/screens/find_friends_screen.dart';
import 'package:fitcoin/features/friends/presentation/screens/friend_requests_screen.dart';
import 'package:fitcoin/features/challenges/presentation/screens/create_challenge_screen.dart';   // ✅ added

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
      builder: (context, state) => const FitcoinScreen(),
    ),
    // ✅ Friend routes
    GoRoute(
      path: '/find-friends',
      builder: (context, state) => const FindFriendsScreen(),
    ),
    GoRoute(
      path: '/friend-requests',
      builder: (context, state) => const FriendRequestsScreen(),
    ),
    // ✅ Challenge creation route
    GoRoute(
      path: '/create-challenge',
      builder: (context, state) => const CreateChallengeScreen(),
    ),
  ],
);