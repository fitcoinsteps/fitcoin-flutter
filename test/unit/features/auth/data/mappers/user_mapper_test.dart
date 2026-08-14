import 'package:flutter_test/flutter_test.dart';
import 'package:fitcoin/features/auth/data/models/user_model.dart';
import 'package:fitcoin/features/auth/data/mappers/user_mapper.dart';

void main() {
  group('UserMapper', () {
    final userModel = UserModel(
      id: '1',
      uuid: 'uuid-123',
      employeeCode: 'EMP001',
      username: 'john_doe',
      firstName: 'John',
      lastName: 'Doe',
      displayName: 'John Doe',
      email: 'john@example.com',
      emailVerifiedAt: true,
      phone: '+123456789',
      phoneVerifiedAt: true,
      status: 'active',
      isActive: true,
      isLocked: false,
      isDeleted: false,
      createdAt: '2024-01-01T00:00:00.000Z',
      updatedAt: '2024-01-02T00:00:00.000Z',
    );

    test('toEntity should convert UserModel to UserEntity correctly', () {
      final entity = UserMapper.toEntity(userModel);
      expect(entity.id, userModel.uuid);
      expect(entity.employeeCode, userModel.employeeCode);
      expect(entity.username, userModel.username);
      expect(entity.firstName, userModel.firstName);
      expect(entity.lastName, userModel.lastName);
      expect(entity.email, userModel.email);
      expect(entity.isEmailVerified, userModel.emailVerifiedAt);
      expect(entity.phone, userModel.phone);
      expect(entity.isPhoneVerified, userModel.phoneVerifiedAt);
      expect(entity.status, userModel.status);
      expect(entity.isActive, userModel.isActive);
      expect(entity.isLocked, userModel.isLocked);
      expect(entity.createdAt, DateTime.parse(userModel.createdAt));
      expect(entity.updatedAt, DateTime.parse(userModel.updatedAt!));
    });

    test('toEntity should handle null values correctly', () {
      final modelWithNulls = UserModel(
        id: '2',
        uuid: 'uuid-456',
        username: 'jane_doe',
        firstName: 'Jane',
        lastName: 'Doe',
        displayName: 'Jane Doe',
        email: 'jane@example.com',
        emailVerifiedAt: false,
        phone: null,
        phoneVerifiedAt: false,
        status: 'active',
        isActive: true,
        isLocked: false,
        isDeleted: false,
        createdAt: '2024-01-01T00:00:00.000Z',
        updatedAt: null,
        deletedAt: null,
        avatar: null,
        employeeCode: null,
        middleName: null,
        lastLoginAt: null,
        lastActivityAt: null,
        lockedUntil: null,
        createdBy: null,
        updatedBy: null,
        deletedBy: null,
        rememberToken: null,
      );

      final entity = UserMapper.toEntity(modelWithNulls);
      expect(entity.employeeCode, '');
      expect(entity.middleName, null);
      expect(entity.phone, null);
      expect(entity.avatar, null);
      expect(entity.updatedAt, null);
    });

    test('toModel should convert UserEntity to UserModel correctly', () {
      final entity = UserMapper.toEntity(userModel);
      final model = UserMapper.toModel(entity);
      expect(model.id, entity.id);
      expect(model.uuid, entity.id);
      expect(model.username, entity.username);
      expect(model.firstName, entity.firstName);
      expect(model.lastName, entity.lastName);
      expect(model.email, entity.email);
      expect(model.status, entity.status);
    });
  });
}