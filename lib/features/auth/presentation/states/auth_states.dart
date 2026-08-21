import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/models/registration_response.dart';

part 'auth_states.freezed.dart';

@freezed
class RegistrationState with _$RegistrationState {
  const factory RegistrationState.initial() = _RegistrationInitial;

  const factory RegistrationState.loading() = _RegistrationLoading;

  const factory RegistrationState.success({
    required RegistrationResponse response,
  }) = _RegistrationSuccess;

  const factory RegistrationState.error({required String message}) =
  _RegistrationError;
}

@freezed
class OtpVerificationState with _$OtpVerificationState {
  const factory OtpVerificationState.initial() = _OtpVerificationInitial;

  const factory OtpVerificationState.loading() = _OtpVerificationLoading;

  const factory OtpVerificationState.success({
    required OtpVerificationResult result,
  }) = _OtpVerificationSuccess;

  const factory OtpVerificationState.error({required String message}) =
  _OtpVerificationError;
}

class OtpVerificationResult {
  final UserEntity user;
  final String accessToken;
  final String refreshToken;
  final int expiresIn;

  const OtpVerificationResult({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
  });
}