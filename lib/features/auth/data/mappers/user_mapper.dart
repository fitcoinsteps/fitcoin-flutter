import '../../domain/entities/user_entity.dart';
import 'package:fitcoin/features/auth/data/models/user_model.dart';

class UserMapper {
  static UserEntity toEntity(UserModel model) {
    return UserEntity(
      id: model.uuid.isNotEmpty ? model.uuid : model.id,
      employeeCode: model.employeeCode ?? '',
      username: model.username,
      firstName: model.firstName,
      middleName: model.middleName,
      lastName: model.lastName,
      displayName: model.displayName,
      email: model.email,
      isEmailVerified: model.emailVerifiedAt,
      phone: model.phone,
      isPhoneVerified: model.phoneVerifiedAt,
      avatar: model.avatar,
      status: model.status,
      isActive: model.isActive,
      isLocked: model.isLocked,
      lastLoginAt: model.lastLoginAt != null
          ? DateTime.parse(model.lastLoginAt!)
          : null,
      lastActivityAt: model.lastActivityAt != null
          ? DateTime.parse(model.lastActivityAt!)
          : null,
      createdAt: DateTime.parse(model.createdAt),
      updatedAt: model.updatedAt != null
          ? DateTime.parse(model.updatedAt!)
          : null,
    );
  }

  static UserModel toModel(UserEntity entity) {
    return UserModel(
      id: entity.id,
      uuid: entity.id,
      employeeCode: entity.employeeCode,
      username: entity.username,
      firstName: entity.firstName,
      middleName: entity.middleName,
      lastName: entity.lastName,
      displayName: entity.displayName,
      email: entity.email,
      emailVerifiedAt: entity.isEmailVerified,
      phone: entity.phone,
      phoneVerifiedAt: entity.isPhoneVerified,
      avatar: entity.avatar,
      status: entity.status,
      isActive: entity.isActive,
      isLocked: entity.isLocked,
      lockedUntil: null,
      isDeleted: entity.isDeleted,
      lastLoginAt: entity.lastLoginAt?.toIso8601String(),
      lastActivityAt: entity.lastActivityAt?.toIso8601String(),
      createdBy: null,
      updatedBy: null,
      deletedBy: null,
      rememberToken: null,
      createdAt: entity.createdAt.toIso8601String(),
      updatedAt: entity.updatedAt?.toIso8601String(),
      deletedAt: null,
    );
  }

  static List<UserEntity> toEntityList(List<UserModel> models) {
    return models.map((model) => toEntity(model)).toList();
  }

  static List<UserModel> toModelList(List<UserEntity> entities) {
    return entities.map((entity) => toModel(entity)).toList();
  }
}