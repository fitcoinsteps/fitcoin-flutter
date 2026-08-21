// lib/core/routing/app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// صفحات المصادقة
import 'package:fitcoin/features/auth/presentation/screens/register_screen.dart';
import 'package:fitcoin/features/auth/presentation/screens/verify_otp_screen.dart';
import 'package:fitcoin/features/login_auth/presentation/screens/login_screen.dart';

// الصفحات الرئيسية
import 'package:fitcoin/features/main/presentation/screens/main_screen.dart';
import 'package:fitcoin/features/home/presentation/screens/home_screen.dart';

// صفحات كلمة المرور المفقودة
import 'package:fitcoin/features/forgot_password/presentation/screens/forgot_password_screen.dart';
import 'package:fitcoin/features/forgot_password/presentation/screens/verify_reset_otp_screen.dart';
import 'package:fitcoin/features/reset_password/presentation/screens/reset_password_screen.dart';

// صفحات التطبيق
import 'package:fitcoin/features/step_counter/presentation/screens/step_dashboard_screen.dart';
import 'package:fitcoin/features/live_tracking/presentation/screens/tracking_screen.dart';
import 'package:fitcoin/features/fitcoin/presentation/screens/fitcoin_screen.dart';
import 'package:fitcoin/features/earnings/presentation/screens/earnings_screen.dart';
import 'package:fitcoin/features/rewards/presentation/screens/rewards_screen.dart';
import 'package:fitcoin/features/profile/presentation/screens/profile_screen.dart';
import 'package:fitcoin/features/scratch_card_screen/scratch_card_screen.dart';

// ======================================================================
// ✅ تم تصحيح مسار الاستيراد هنا ليتطابق مع مجلدك الحقيقي
// ======================================================================
import 'package:fitcoin/features/spin_screen/spin_screen.dart';


final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    // مسارات المصادقة
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

    // مسارات التطبيق الرئيسية
    GoRoute(
      path: '/',
      builder: (context, state) => const MainScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
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

    // المسارات المخصصة
    GoRoute(
      path: '/earnings',
      builder: (context, state) => const EarningsScreen(),
    ),
    GoRoute(
      path: '/rewards',
      builder: (context, state) => const RewardsScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/scratch',
      builder: (context, state) => const ScratchCardScreen(),
    ),
    GoRoute(
      path: '/spin',
      builder: (context, state) => const SpinScreen(),
    ),
  ],
);