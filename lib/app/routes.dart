import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/home/presentation/pages/home_page.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/register_page.dart';
import '../features/bookings/presentation/pages/bookings_page.dart';
import '../features/payments/presentation/pages/payment_page.dart';
import '../features/profile/presentation/pages/profile_page.dart';
import '../features/notifications/presentation/pages/notifications_page.dart';
import '../navigation/app_shell.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    // ✅ CHANGE THIS: Go directly to home (skip login)
    initialLocation: '/',  // ← This goes to home page directly

    // OR if you want to see splash screen first:
    // initialLocation: '/splash',

    debugLogDiagnostics: true,
    redirect: (context, state) {
      // ✅ DISABLE AUTH GUARD FOR NOW
      // Just return null to allow all navigation
      return null;
    },
    routes: [
      // ✅ Add optional splash route
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterPage(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          return AppShell(child: child);
        },
        routes: [
          GoRoute(
            path: '/',
            name: 'home',
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: '/bookings',
            name: 'bookings',
            builder: (context, state) => const BookingsPage(),
          ),
          GoRoute(
            path: '/payments',
            name: 'payments',
            builder: (context, state) => const PaymentPage(),
          ),
          GoRoute(
            path: '/notifications',
            name: 'notifications',
            builder: (context, state) => const NotificationsPage(),
          ),
          GoRoute(
            path: '/profile',
            name: 'profile',
            builder: (context, state) => const ProfilePage(),
          ),
        ],
      ),
    ],
  );
});

// Optional: Splash screen to show app logo first
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      context.go('/');
    });

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.monetization_on,
                size: 60,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Fitcoin',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 40),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}