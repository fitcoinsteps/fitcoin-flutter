import 'flavor.dart';

class AppConfig {
  final Flavor flavor;
  final String baseUrl;
  final String apiBaseUrl;
  final bool debugMode;
  final bool enableLogging;
  final bool enableAnalytics;
  final bool useMockData;
  final String sentryDsn;

  const AppConfig({
    required this.flavor,
    required this.baseUrl,
    required this.apiBaseUrl,
    required this.debugMode,
    required this.enableLogging,
    required this.enableAnalytics,
    required this.useMockData,
    required this.sentryDsn,
  });

  // Development config
  static const AppConfig development = AppConfig(
    flavor: Flavor.development,
    baseUrl: 'http://localhost:3000',
    apiBaseUrl: 'http://localhost:8000/api',
    debugMode: true,
    enableLogging: true,
    enableAnalytics: false,
    useMockData: true,
    sentryDsn: '',
  );

  // Staging config
  static const AppConfig staging = AppConfig(
    flavor: Flavor.staging,
    baseUrl: 'https://staging.fitcoin.com',
    apiBaseUrl: 'https://staging.fitcoin.com/api',
    debugMode: true,
    enableLogging: true,
    enableAnalytics: true,
    useMockData: false,
    sentryDsn: 'https://your-staging-sentry-dsn',
  );

  // Production config
  static const AppConfig production = AppConfig(
    flavor: Flavor.production,
    baseUrl: 'https://api.fitcoin.com',
    apiBaseUrl: 'https://api.fitcoin.com/api',
    debugMode: false,
    enableLogging: false,
    enableAnalytics: true,
    useMockData: false,
    sentryDsn: 'https://your-production-sentry-dsn',
  );

  static AppConfig fromFlavor(Flavor flavor) {
    switch (flavor) {
      case Flavor.development:
        return AppConfig.development;
      case Flavor.staging:
        return AppConfig.staging;
      case Flavor.production:
        return AppConfig.production;
    }
  }
}