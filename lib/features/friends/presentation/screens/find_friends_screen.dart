import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitcoin/features/friends/presentation/providers/friends_providers.dart';
import 'package:fitcoin/features/friends/presentation/states/friends_states.dart';

class FindFriendsScreen extends ConsumerStatefulWidget {
  const FindFriendsScreen({super.key});

  @override
  ConsumerState<FindFriendsScreen> createState() => _FindFriendsScreenState();
}

class _FindFriendsScreenState extends ConsumerState<FindFriendsScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _search() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      ref.read(searchUsersControllerProvider.notifier).search(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchUsersControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Find Friends')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search by name, username, or email',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _search(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _search,
                  child: const Text('Search'),
                ),
              ],
            ),
          ),
          Expanded(
            child: searchState is SearchUsersLoading
                ? const Center(child: CircularProgressIndicator())
                : searchState is SearchUsersError
                ? Center(child: Text(searchState.message))
                : searchState is SearchUsersLoaded
                ? ListView.builder(
              itemCount: searchState.users.length,
              itemBuilder: (context, index) {
                final user = searchState.users[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(user.name.isNotEmpty
                        ? user.name[0].toUpperCase()
                        : '?'),
                  ),
                  title: Text(user.name),
                  subtitle: Text('@${user.username}'),
                  trailing: ElevatedButton(
                    onPressed: () async {
                      await ref
                          .read(sendFriendRequestAction)
                          .call(user.id);
                      // Optionally show a snackbar
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Friend request sent!')),
                      );
                    },
                    child: const Text('Add'),
                  ),
                );
              },
            )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}