import 'package:fitcoin/features/login_auth/domain/entities/login_user_entity.dart';

class LoginResponse {
  final String accessToken;
  final String refreshToken;   // <-- must be present
  final String tokenType;
  final int expiresIn;
  final LoginUserEntity user;

  LoginResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
    required this.expiresIn,
    required this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['access_token'] ?? '',
      refreshToken: json['refresh_token'] ?? '',   // <-- parse refresh token
      tokenType: json['token_type'] ?? 'bearer',
      expiresIn: json['expires_in'] ?? 3600,
      user: LoginUserEntity(
        id: json['user']['id']?.toString() ?? '',
        uuid: json['user']['uuid'] ?? '',
        username: json['user']['username'] ?? '',
        firstName: json['user']['first_name'] ?? '',
        lastName: json['user']['last_name'] ?? '',
        email: json['user']['email'] ?? '',
        isActive: json['user']['is_active'] == 1 || json['user']['is_active'] == true,
        role: json['user']['role'] ?? 'user',  // <-- changed to role string
      ),
    );
  }
}