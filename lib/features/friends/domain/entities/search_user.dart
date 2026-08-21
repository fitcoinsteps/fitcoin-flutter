class SearchUser {
  final int id;
  final String name;
  final String username;
  final String? avatarUrl;
  final bool isOnline;

  const SearchUser({
    required this.id,
    required this.name,
    required this.username,
    required this.avatarUrl,
    required this.isOnline,
  });
}