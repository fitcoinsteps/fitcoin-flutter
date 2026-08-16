class UserModel {
  final String id;
  final String uuid;
  final String? employeeCode;
  final String username;
  final String firstName;
  final String? middleName;
  final String lastName;
  final String displayName;
  final String email;
  final bool emailVerifiedAt;
  final String? phone;
  final bool phoneVerifiedAt;
  final String? avatar;
  final String status;
  final bool isActive;
  final bool isLocked;
  final String? lockedUntil;
  final bool isDeleted;
  final String? lastLoginAt;
  final String? lastActivityAt;
  final String? createdBy;
  final String? updatedBy;
  final String? deletedBy;
  final String? rememberToken;
  final String createdAt;
  final String? updatedAt;
  final String? deletedAt;

  UserModel({
    required this.id,
    required this.uuid,
    this.employeeCode,
    required this.username,
    required this.firstName,
    this.middleName,
    required this.lastName,
    required this.displayName,
    required this.email,
    required this.emailVerifiedAt,
    this.phone,
    required this.phoneVerifiedAt,
    this.avatar,
    required this.status,
    required this.isActive,
    required this.isLocked,
    this.lockedUntil,
    required this.isDeleted,
    this.lastLoginAt,
    this.lastActivityAt,
    this.createdBy,
    this.updatedBy,
    this.deletedBy,
    this.rememberToken,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      uuid: json['uuid'] ?? '',
      employeeCode: json['employee_code'],
      username: json['username'] ?? '',
      firstName: json['first_name'] ?? '',
      middleName: json['middle_name'],
      lastName: json['last_name'] ?? '',
      displayName: json['display_name'] ?? '',
      email: json['email'] ?? '',
      emailVerifiedAt: json['email_verified_at'] != null,
      phone: json['phone'],
      phoneVerifiedAt: json['phone_verified_at'] != null,
      avatar: json['avatar'],
      status: json['status'] ?? 'active',
      // ✅ Fix: Handle both int and bool for is_active
      isActive: _parseBool(json['is_active']),
      isLocked: _parseBool(json['is_locked']),
      lockedUntil: json['locked_until'],
      isDeleted: _parseBool(json['is_deleted']),
      lastLoginAt: json['last_login_at'],
      lastActivityAt: json['last_activity_at'],
      createdBy: json['created_by'],
      updatedBy: json['updated_by'],
      deletedBy: json['deleted_by'],
      rememberToken: json['remember_token'],
      createdAt: json['created_at'] ?? DateTime.now().toIso8601String(),
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uuid': uuid,
      'employee_code': employeeCode,
      'username': username,
      'first_name': firstName,
      'middle_name': middleName,
      'last_name': lastName,
      'display_name': displayName,
      'email': email,
      'email_verified_at': emailVerifiedAt
          ? DateTime.now().toIso8601String()
          : null,
      'phone': phone,
      'phone_verified_at': phoneVerifiedAt
          ? DateTime.now().toIso8601String()
          : null,
      'avatar': avatar,
      'status': status,
      'is_active': isActive,
      'is_locked': isLocked,
      'locked_until': lockedUntil,
      'is_deleted': isDeleted,
      'last_login_at': lastLoginAt,
      'last_activity_at': lastActivityAt,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'deleted_by': deletedBy,
      'remember_token': rememberToken,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }

  // ✅ Helper method to parse bool from int, bool, or string
  static bool _parseBool(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) {
      return value == '1' || value.toLowerCase() == 'true';
    }
    return false;
  }
}