class UserProfile {
  final String id;
  final String uuid;
  final String username;
  final String firstName;
  final String lastName;
  final String displayName;
  final String email;
  final String phone;
  final String role;
  final String? avatarUrl;
  final int fitcoinBalance;
  final int todaySteps;
  final int dailyGoal;

  UserProfile({
    required this.id,
    required this.uuid,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.displayName,
    required this.email,
    required this.phone,
    required this.role,
    required this.avatarUrl,
    required this.fitcoinBalance,
    required this.todaySteps,
    required this.dailyGoal,
  });
}