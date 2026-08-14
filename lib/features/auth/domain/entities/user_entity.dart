import 'package:equatable/equatable.dart';

/// Pure domain entity representing a user.
/// Contains only business-relevant fields with proper types.
class UserEntity extends Equatable {
  final String id;
  final String employeeCode;
  final String username;
  final String firstName;
  final String? middleName;
  final String lastName;
  final String displayName;
  final String email;
  final bool isEmailVerified;
  final String? phone;
  final bool isPhoneVerified;
  final String? avatar;
  final String status;
  final bool isActive;
  final bool isLocked;
  final DateTime? lastLoginAt;
  final DateTime? lastActivityAt;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const UserEntity({
    required this.id,
    required this.employeeCode,
    required this.username,
    required this.firstName,
    this.middleName,
    required this.lastName,
    required this.displayName,
    required this.email,
    this.isEmailVerified = false,
    this.phone,
    this.isPhoneVerified = false,
    this.avatar,
    this.status = 'active',
    this.isActive = true,
    this.isLocked = false,
    this.lastLoginAt,
    this.lastActivityAt,
    required this.createdAt,
    this.updatedAt,
  });

  String get fullName =>
      '$firstName ${middleName != null ? '$middleName ' : ''}$lastName';

  bool get isAdmin => status == 'admin' || status == 'super_admin';

  bool get isDeleted => status == 'deleted';

  @override
  List<Object?> get props => [
    id,
    employeeCode,
    username,
    firstName,
    middleName,
    lastName,
    displayName,
    email,
    isEmailVerified,
    phone,
    isPhoneVerified,
    avatar,
    status,
    isActive,
    isLocked,
    lastLoginAt,
    lastActivityAt,
    createdAt,
    updatedAt,
  ];

  UserEntity copyWith({
    String? id,
    String? employeeCode,
    String? username,
    String? firstName,
    String? middleName,
    String? lastName,
    String? displayName,
    String? email,
    bool? isEmailVerified,
    String? phone,
    bool? isPhoneVerified,
    String? avatar,
    String? status,
    bool? isActive,
    bool? isLocked,
    DateTime? lastLoginAt,
    DateTime? lastActivityAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserEntity(
      id: id ?? this.id,
      employeeCode: employeeCode ?? this.employeeCode,
      username: username ?? this.username,
      firstName: firstName ?? this.firstName,
      middleName: middleName ?? this.middleName,
      lastName: lastName ?? this.lastName,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      phone: phone ?? this.phone,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      avatar: avatar ?? this.avatar,
      status: status ?? this.status,
      isActive: isActive ?? this.isActive,
      isLocked: isLocked ?? this.isLocked,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      lastActivityAt: lastActivityAt ?? this.lastActivityAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
