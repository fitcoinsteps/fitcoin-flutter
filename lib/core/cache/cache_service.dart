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

  // ==================== ACCESS TOKEN ====================
  static String? getToken() {
    return Hive.box(_cacheBox).get('access_token');
  }

  static void cacheToken(String token) {
    Hive.box(_cacheBox).put('access_token', token);
  }

  // ==================== REFRESH TOKEN ====================
  static String? getRefreshToken() {
    return Hive.box(_cacheBox).get('refresh_token');
  }

  static void cacheRefreshToken(String refreshToken) {
    Hive.box(_cacheBox).put('refresh_token', refreshToken);
  }

  // ==================== TOKEN EXPIRY ====================
  static int? getTokenExpiry() {
    return Hive.box(_cacheBox).get('token_expiry');
  }

  static void cacheTokenExpiry(int expiresIn) {
    final expiryTime = DateTime.now().millisecondsSinceEpoch + (expiresIn * 1000);
    Hive.box(_cacheBox).put('token_expiry', expiryTime);
  }

  static bool isTokenExpired() {
    final expiry = getTokenExpiry();
    if (expiry == null) return true;
    return DateTime.now().millisecondsSinceEpoch > expiry;
  }

  static bool isLoggedIn() => getToken() != null;

  static void clearAll() {
    Hive.box(_userBox).clear();
    Hive.box(_cacheBox).clear();
  }

  // ==================== USER ====================
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

  void logout() {
    _logger.d('Logging out');
    clearAll();
  }
}