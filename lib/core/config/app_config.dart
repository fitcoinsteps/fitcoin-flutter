import 'flavor.dart';

class AppConfig {
  final Flavor flavor;
  final String apiBaseUrl;
  final String googleMapsApiKey; // <-- added
  final bool debugMode;
  final bool enableLogging;
  final bool enableAnalytics;
  final bool useMockData;
  final String sentryDsn;

  const AppConfig({
    required this.flavor,
    required this.apiBaseUrl,
    required this.googleMapsApiKey, // <-- added
    required this.debugMode,
    required this.enableLogging,
    required this.enableAnalytics,
    required this.useMockData,
    required this.sentryDsn,
  });

  static const AppConfig development = AppConfig(
    flavor: Flavor.development,
    apiBaseUrl: 'http://10.0.0.98:8000/api',
    googleMapsApiKey: 'AIzaSyB2oIEcWiWQo3cvElqVw5Bpb8f-c6bKXIU', // <-- your key
    debugMode: true,
    enableLogging: true,
    enableAnalytics: false,
    useMockData: false,
    sentryDsn: '',
  );

  static const AppConfig staging = AppConfig(
    flavor: Flavor.staging,
    apiBaseUrl: 'https://fit-coin.net/api',
    googleMapsApiKey: 'AIzaSyB2oIEcWiWQo3cvElqVw5Bpb8f-c6bKXIU', // <-- same or different
    debugMode: true,
    enableLogging: true,
    enableAnalytics: true,
    useMockData: false,
    sentryDsn: '',
  );

  static const AppConfig production = AppConfig(
    flavor: Flavor.production,
    apiBaseUrl: 'https://fit-coin.net/api',
    googleMapsApiKey: 'AIzaSyB2oIEcWiWQo3cvElqVw5Bpb8f-c6bKXIU', // <-- same
    debugMode: false,
    enableLogging: false,
    enableAnalytics: true,
    useMockData: false,
    sentryDsn: '',
  );

  static AppConfig fromFlavor(Flavor flavor) {
    switch (flavor) {
      case Flavor.development:
        return development;
      case Flavor.staging:
        return staging;
      case Flavor.production:
        return production;
    }
  }

  static late AppConfig _instance;

  static void initialize(Flavor flavor) {
    _instance = fromFlavor(flavor);
  }

  static AppConfig get current {
    try {
      return _instance;
    } catch (_) {
      return development;
    }
  }
}