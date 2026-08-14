import 'package:equatable/equatable.dart';

class RegistrationResponse extends Equatable {
  final String message;
  final String email;
  final String redirect;

  const RegistrationResponse({
    required this.message,
    required this.email,
    required this.redirect,
  });

  factory RegistrationResponse.fromJson(Map<String, dynamic> json) {
    return RegistrationResponse(
      message: json['message'] ?? '',
      email: json['email'] ?? '',
      redirect: json['redirect'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'message': message, 'email': email, 'redirect': redirect};
  }

  @override
  List<Object?> get props => [message, email, redirect];
}
