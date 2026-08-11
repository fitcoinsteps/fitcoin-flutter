enum Flavor {
  development,
  staging,
  production;

  static Flavor fromString(String value) {
    switch (value.toLowerCase()) {
      case 'development':
        return Flavor.development;
      case 'staging':
        return Flavor.staging;
      case 'production':
        return Flavor.production;
      default:
        return Flavor.development;
    }
  }

  String get stringValue {
    switch (this) {
      case Flavor.development:
        return 'development';
      case Flavor.staging:
        return 'staging';
      case Flavor.production:
        return 'production';
    }
  }
}