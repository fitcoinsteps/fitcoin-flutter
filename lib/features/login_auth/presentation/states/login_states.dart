import 'package:fitcoin/features/login_auth/domain/models/login_response.dart';

sealed class LoginState {
  const LoginState();
}

class LoginInitial extends LoginState {
  const LoginInitial();
}

class LoginLoading extends LoginState {
  const LoginLoading();
}

class LoginSuccess extends LoginState {
  final LoginResponse response;
  const LoginSuccess(this.response);
}

class LoginError extends LoginState {
  final String message;
  const LoginError(this.message);
}