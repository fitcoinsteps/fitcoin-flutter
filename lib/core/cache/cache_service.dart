import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:fitcoin/core/logger/app_logger.dart';
import 'adapters/user_entity_adapter.dart';
import 'package:fitcoin/features/auth/domain/entities/user_entity.dart';

final cacheServiceProvider = Provider<CacheService>((ref) {
  return CacheService(ref.watch(loggerProvider));
});

class CacheService {
  final Logger _logger;

  static const String _userBox = 'user_box';
  static const String _cacheBox = 'cache_box';

  CacheService(this._logger);

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(UserEntityAdapter());
    await Hive.openBox(_userBox);
    await Hive.openBox(_cacheBox);
  }

  static String? getToken() {
    return Hive.box(_cacheBox).get('access_token');
  }

  static bool isLoggedIn() => getToken() != null;

  static void clearAll() {
    Hive.box(_userBox).clear();
    Hive.box(_cacheBox).clear();
  }

  Box getUserBox() => Hive.box(_userBox);

  Box getCacheBox() => Hive.box(_cacheBox);

  void cacheUserEntity(UserEntity user) {
    _logger.d('Caching user: ${user.email}');

    final box = getUserBox();
    box
      ..put('current_user_entity', user)
      ..put('user_email', user.email)
      ..put('user_id', user.id);
  }

  UserEntity? getCachedUserEntity() {
    final user = getUserBox().get('current_user_entity');

    if (user != null) {
      _logger.d('Retrieved cached user entity');
    }

    return user as UserEntity?;
  }

  void cacheUser(Map<String, dynamic> user) {
    _logger.d('Caching user: ${user['email']}');

    final box = getUserBox();
    box
      ..put('current_user', user)
      ..put('user_email', user['email'])
      ..put('user_id', user['id']);
  }

  Map<String, dynamic>? getCachedUser() {
    final user = getUserBox().get('current_user');

    if (user != null) {
      _logger.d('Retrieved cached user');
    }

    return user as Map<String, dynamic>?;
  }

  void clearUser() {
    _logger.d('Clearing user cache');
    getUserBox().clear();
  }

  void cacheToken(String token) {
    _logger.d('Caching token');
    getCacheBox().put('access_token', token);
  }

  String? getCachedToken() {
    return getCacheBox().get('access_token');
  }

  void cacheData(String key, dynamic value) {
    _logger.d('Caching data: $key');
    getCacheBox().put(key, value);
  }

  dynamic getCachedData(String key) {
    return getCacheBox().get(key);
  }

  void clearCache() {
    _logger.d('Clearing generic cache');
    getCacheBox().clear();
  }

  void logout() {
    _logger.d('Logging out');
    clearAll();
  }
}