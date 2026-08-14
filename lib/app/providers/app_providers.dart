import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitcoin/core/config/app_config.dart';

final appConfigProvider = Provider<AppConfig>((ref) {
  throw UnimplementedError('Should be overridden in bootstrap');
});

final baseUrlProvider = Provider<String>((ref) {
  return ref.watch(appConfigProvider).apiBaseUrl;
});

final debugModeProvider = Provider<bool>((ref) {
  return ref.watch(appConfigProvider).debugMode;
});

final mockDataProvider = Provider<bool>((ref) {
  return ref.watch(appConfigProvider).useMockData;
});
