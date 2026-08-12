import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import '../logger/app_logger.dart'; // Import the logger provider

final cacheServiceProvider = Provider<CacheService>((ref) {
  final logger = ref.watch(loggerProvider);
  return CacheService(logger);
});

class CacheService {
  final Logger _logger;

  static const String _userBox = 'user_box';
  static const String _bookingBox = 'booking_box';
  static const String _settingsBox = 'settings_box';
  static const String _cacheBox = 'cache_box';

  CacheService(this._logger);

  Future<void> init() async {
    _logger.d('Initializing Hive...');
    await Hive.initFlutter();
    await Hive.openBox(_userBox);
    await Hive.openBox(_bookingBox);
    await Hive.openBox(_settingsBox);
    await Hive.openBox(_cacheBox);
    _logger.d('Hive initialized successfully');
  }

  Box getUserBox() => Hive.box(_userBox);
  Box getBookingBox() => Hive.box(_bookingBox);
  Box getSettingsBox() => Hive.box(_settingsBox);
  Box getCacheBox() => Hive.box(_cacheBox);

  // User cache
  void cacheUser(Map<String, dynamic> user) {
    _logger.d('Caching user: ${user['email']}');
    final box = getUserBox();
    box.put('current_user', user);
    box.put('user_email', user['email']);
    box.put('user_id', user['id']);
  }

  Map<String, dynamic>? getCachedUser() {
    final box = getUserBox();
    final user = box.get('current_user');
    if (user != null) {
      _logger.d('Retrieved cached user');
    }
    return user as Map<String, dynamic>?;
  }

  void clearUser() {
    _logger.d('Clearing user cache');
    final box = getUserBox();
    box.clear();
  }

  // Token cache methods
  void cacheToken(String token) {
    _logger.d('Caching token');
    final box = getCacheBox();
    box.put('access_token', token);
  }

  String? getCachedToken() {
    final box = getCacheBox();
    return box.get('access_token');
  }

  // Generic cache
  void cacheData(String key, dynamic value) {
    _logger.d('Caching data: $key');
    final box = getCacheBox();
    box.put(key, value);
  }

  dynamic getCachedData(String key) {
    final box = getCacheBox();
    return box.get(key);
  }

  void clearCache() {
    _logger.d('Clearing all cache');
    final box = getCacheBox();
    box.clear();
  }

  // Settings
  void setSetting(String key, dynamic value) {
    _logger.d('Setting: $key = $value');
    final box = getSettingsBox();
    box.put(key, value);
  }

  dynamic getSetting(String key) {
    final box = getSettingsBox();
    return box.get(key);
  }

  bool getBoolSetting(String key, {bool defaultValue = false}) {
    final box = getSettingsBox();
    return box.get(key, defaultValue: defaultValue) as bool;
  }

  String getStringSetting(String key, {String defaultValue = ''}) {
    final box = getSettingsBox();
    return box.get(key, defaultValue: defaultValue) as String;
  }
}