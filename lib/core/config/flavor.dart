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

  String get baseUrl {
    switch (this) {
      case Flavor.development:
        return 'http://10.0.0.184:8000/api';
      case Flavor.staging:
        return 'https://fit-coin.net';
      case Flavor.production:
        return 'https://fit-coin.net';
    }
  }
}
