import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitcoin/features/friends/presentation/providers/friends_providers.dart';
import 'package:fitcoin/features/friends/presentation/states/friends_states.dart';

class FriendRequestsScreen extends ConsumerStatefulWidget {
  const FriendRequestsScreen({super.key});

  @override
  ConsumerState<FriendRequestsScreen> createState() =>
      _FriendRequestsScreenState();
}

class _FriendRequestsScreenState extends ConsumerState<FriendRequestsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(friendRequestsControllerProvider.notifier).loadRequests();
    });
  }

  @override
  Widget build(BuildContext context) {
    final requestsState = ref.watch(friendRequestsControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Friend Requests')),
      body: requestsState is FriendRequestsLoading
          ? const Center(child: CircularProgressIndicator())
          : requestsState is FriendRequestsError
          ? Center(child: Text(requestsState.message))
          : requestsState is FriendRequestsLoaded
          ? ListView.builder(
        itemCount: requestsState.requests.length,
        itemBuilder: (context, index) {
          final request = requestsState.requests[index];
          final isIncoming = request.senderId != 0;
          final person = isIncoming
              ? request.senderName
              : request.receiverName;
          return ListTile(
            leading: CircleAvatar(
              child: Text(person.isNotEmpty
                  ? person[0].toUpperCase()
                  : '?'),
            ),
            title: Text(person),
            subtitle: Text(isIncoming
                ? 'Wants to be your friend'
                : 'Request sent'),
            trailing: isIncoming
                ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.check,
                      color: Colors.green),
                  onPressed: () async {
                    await ref
                        .read(acceptFriendRequestAction)
                        .call(request.friendshipId);
                    ref
                        .read(
                        friendRequestsControllerProvider
                            .notifier)
                        .loadRequests();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.close,
                      color: Colors.red),
                  onPressed: () async {
                    await ref
                        .read(rejectFriendRequestAction)
                        .call(request.friendshipId);
                    ref
                        .read(
                        friendRequestsControllerProvider
                            .notifier)
                        .loadRequests();
                  },
                ),
              ],
            )
                : null,
          );
        },
      )
          : const SizedBox.shrink(),
    );
  }
}