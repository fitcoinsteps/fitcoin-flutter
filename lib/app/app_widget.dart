import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'routes.dart';
import 'providers/app_providers.dart';
import '../core/config/flavor.dart';

class AppWidget extends ConsumerWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final config = ref.watch(appConfigProvider);
    // ✅ FIX: Remove logger if not available, or add the provider

    return MaterialApp.router(
      title: 'Fitcoin ${config.flavor.stringValue.toUpperCase()}',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      routerConfig: router,
      debugShowCheckedModeBanner: config.debugMode,
      builder: (context, child) {
        if (config.debugMode) {
          return Stack(
            children: [
              // ✅ FIX: Use null-aware operator instead of if check
              child ?? const SizedBox.shrink(),
              const Positioned(
                top: 40,
                right: 8,
                child: _EnvironmentBanner(),
              ),
            ],
          );
        }
        return child ?? const SizedBox.shrink();
      },
    );
  }
}

class _EnvironmentBanner extends ConsumerWidget {
  const _EnvironmentBanner();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(appConfigProvider);
    final flavor = config.flavor;

    // ✅ FIX: Add default case to ensure color is always assigned
    Color color;
    switch (flavor) {
      case Flavor.development:
        color = Colors.red;
        break;
      case Flavor.staging:
        color = Colors.orange;
        break;
      case Flavor.production:
        color = Colors.green;
        break;
      default:
        color = Colors.grey; // Fallback (never reached but satisfies linter)
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            // ✅ FIX: Use withValues() instead of deprecated withOpacity
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Text(
        flavor.stringValue.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}