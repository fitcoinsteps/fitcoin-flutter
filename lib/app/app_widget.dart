import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'routes.dart';
import '../core/config/flavor.dart';

final appConfigProvider = Provider<AppConfig>((ref) {
  return AppConfig.development;
});

final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.light);

class AppConfig {
  final Flavor flavor;
  final bool debugMode;
  final String baseUrl;
  final String apiBaseUrl;
  final bool enableLogging;
  final bool enableAnalytics;
  final bool useMockData;
  final String sentryDsn;

  const AppConfig({
    required this.flavor,
    required this.debugMode,
    required this.baseUrl,
    required this.apiBaseUrl,
    required this.enableLogging,
    required this.enableAnalytics,
    required this.useMockData,
    required this.sentryDsn,
  });

  static const AppConfig development = AppConfig(
    flavor: Flavor.development,
    debugMode: true,
    baseUrl: 'http://localhost:3000',
    apiBaseUrl: 'http://localhost:8000/api',
    enableLogging: true,
    enableAnalytics: false,
    useMockData: true,
    sentryDsn: '',
  );
}

class AppWidget extends ConsumerWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final config = ref.watch(appConfigProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'Fitcoin ${config.flavor.stringValue.toUpperCase()}',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      themeMode: themeMode,
      routerConfig: router,
      debugShowCheckedModeBanner: config.debugMode,
    );
  }
}