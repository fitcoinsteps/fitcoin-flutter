class LoginUserEntity {
  final String id;
  final String uuid;
  final String username;
  final String firstName;
  final String lastName;
  final String email;
  final bool isActive;
  final List<String> roles;

  LoginUserEntity({
    required this.id,
    required this.uuid,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.isActive,
    required this.roles,
  });
}