import 'package:hive/hive.dart';
import 'package:fitcoin/features/auth/domain/entities/user_entity.dart';

class UserEntityAdapter extends TypeAdapter<UserEntity> {
  @override
  final int typeId = 0;

  @override
  UserEntity read(BinaryReader reader) {
    return UserEntity(
      id: reader.readString(),
      employeeCode: reader.readString(),
      username: reader.readString(),
      firstName: reader.readString(),
      middleName: reader.readString(),
      lastName: reader.readString(),
      displayName: reader.readString(),
      email: reader.readString(),
      isEmailVerified: reader.readBool(),
      phone: reader.readString(),
      isPhoneVerified: reader.readBool(),
      avatar: reader.readString(),
      status: reader.readString(),
      isActive: reader.readBool(),
      isLocked: reader.readBool(),
      lastLoginAt: _readDateTime(reader),
      lastActivityAt: _readDateTime(reader),
      createdAt: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
      updatedAt: _readDateTime(reader),
    );
  }

  @override
  void write(BinaryWriter writer, UserEntity obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.employeeCode);
    writer.writeString(obj.username);
    writer.writeString(obj.firstName);
    writer.writeString(obj.middleName ?? '');
    writer.writeString(obj.lastName);
    writer.writeString(obj.displayName);
    writer.writeString(obj.email);
    writer.writeBool(obj.isEmailVerified);
    writer.writeString(obj.phone ?? '');
    writer.writeBool(obj.isPhoneVerified);
    writer.writeString(obj.avatar ?? '');
    writer.writeString(obj.status);
    writer.writeBool(obj.isActive);
    writer.writeBool(obj.isLocked);
    _writeDateTime(writer, obj.lastLoginAt);
    _writeDateTime(writer, obj.lastActivityAt);
    writer.writeInt(obj.createdAt.millisecondsSinceEpoch);
    _writeDateTime(writer, obj.updatedAt);
  }

  static DateTime? _readDateTime(BinaryReader reader) {
    final value = reader.readInt();
    return value == -1 ? null : DateTime.fromMillisecondsSinceEpoch(value);
  }

  static void _writeDateTime(BinaryWriter writer, DateTime? dateTime) {
    writer.writeInt(dateTime?.millisecondsSinceEpoch ?? -1);
  }
}