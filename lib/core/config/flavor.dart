enum Flavor {
  development,
  staging,
  production;

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