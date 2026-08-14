import 'package:flutter_test/flutter_test.dart';
import 'package:fitcoin/features/auth/domain/entities/user_entity.dart';

void main() {
  group('UserEntity', () {
    final user = UserEntity(
      id: '1',
      employeeCode: 'EMP001',
      username: 'john_doe',
      firstName: 'John',
      middleName: 'Michael',
      lastName: 'Doe',
      displayName: 'John Doe',
      email: 'john@example.com',
      isEmailVerified: true,
      phone: '+123456789',
      isPhoneVerified: true,
      status: 'active',
      isActive: true,
      isLocked: false,
      createdAt: DateTime(2024, 1, 1),
    );

    test('fullName should combine first, middle, and last', () {
      expect(user.fullName, 'John Michael Doe');
    });

    test('fullName should handle null middleName', () {
      final userNoMiddle = UserEntity(
        id: '2',
        employeeCode: 'EMP002',
        username: 'jane_doe',
        firstName: 'Jane',
        lastName: 'Doe',
        displayName: 'Jane Doe',
        email: 'jane@example.com',
        createdAt: DateTime(2024, 1, 1),
      );
      expect(userNoMiddle.fullName, 'Jane Doe');
    });

    test('isAdmin should be true for admin', () {
      final admin = UserEntity(
        id: '3',
        employeeCode: 'EMP003',
        username: 'admin',
        firstName: 'Admin',
        lastName: 'User',
        displayName: 'Admin User',
        email: 'admin@example.com',
        status: 'admin',
        createdAt: DateTime(2024, 1, 1),
      );
      expect(admin.isAdmin, true);
    });

    test('isAdmin should be true for super_admin', () {
      final superAdmin = UserEntity(
        id: '4',
        employeeCode: 'EMP004',
        username: 'super_admin',
        firstName: 'Super',
        lastName: 'Admin',
        displayName: 'Super Admin',
        email: 'super@example.com',
        status: 'super_admin',
        createdAt: DateTime(2024, 1, 1),
      );
      expect(superAdmin.isAdmin, true);
    });

    test('isAdmin should be false for regular user', () {
      expect(user.isAdmin, false);
    });

    test('isDeleted should be true when status is deleted', () {
      final deleted = UserEntity(
        id: '5',
        employeeCode: 'EMP005',
        username: 'deleted_user',
        firstName: 'Deleted',
        lastName: 'User',
        displayName: 'Deleted User',
        email: 'deleted@example.com',
        status: 'deleted',
        createdAt: DateTime(2024, 1, 1),
      );
      expect(deleted.isDeleted, true);
    });

    test('copyWith should create a new instance with updated fields', () {
      final updated = user.copyWith(
        firstName: 'Jonathan',
        lastName: 'Smith',
      );
      expect(updated.firstName, 'Jonathan');
      expect(updated.lastName, 'Smith');
      expect(updated.id, user.id);
      expect(updated.email, user.email);
    });
  });
}