import 'package:equatable/equatable.dart';

class RegistrationResponse extends Equatable {
  final bool success;
  final String message;
  final String? email;
  final String? redirect;
  final String? token;

  const RegistrationResponse({
    required this.success,
    required this.message,
    this.email,
    this.redirect,
    this.token,
  });

  factory RegistrationResponse.fromJson(Map<String, dynamic> json) {
    return RegistrationResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      email: json['email'],
      redirect: json['redirect'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'email': email,
      'redirect': redirect,
      'token': token,
    };
  }

  @override
  List<Object?> get props => [success, message, email, redirect, token];
}