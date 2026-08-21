import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitcoin/features/friends/data/datasources/friends_remote_source.dart';
import 'package:fitcoin/features/friends/data/repositories/friends_repository_impl.dart';
import 'package:fitcoin/features/friends/domain/repositories/friends_repository.dart';
import 'package:fitcoin/features/friends/domain/usecases/get_friends.dart';
import 'package:fitcoin/features/friends/domain/usecases/search_users.dart';
import 'package:fitcoin/features/friends/domain/usecases/send_friend_request.dart';
import 'package:fitcoin/features/friends/domain/usecases/accept_friend_request.dart';
import 'package:fitcoin/features/friends/domain/usecases/reject_friend_request.dart';
import 'package:fitcoin/features/friends/domain/usecases/get_pending_requests.dart';
import 'package:fitcoin/features/friends/domain/usecases/remove_friend.dart';
import 'package:fitcoin/features/friends/presentation/controllers/friends_controller.dart';
import 'package:fitcoin/features/friends/presentation/controllers/search_users_controller.dart';
import 'package:fitcoin/features/friends/presentation/controllers/friend_requests_controller.dart';
import 'package:fitcoin/features/friends/presentation/states/friends_states.dart';

final friendsRemoteSourceProvider = Provider<FriendsRemoteSource>((ref) {
  return FriendsRemoteSource();
});

final friendsRepositoryProvider = Provider<FriendsRepository>((ref) {
  return FriendsRepositoryImpl(remoteSource: ref.watch(friendsRemoteSourceProvider));
});

// Use cases
final getFriendsProvider = Provider<GetFriends>((ref) {
  return GetFriends(ref.watch(friendsRepositoryProvider));
});

final searchUsersProvider = Provider<SearchUsers>((ref) {
  return SearchUsers(ref.watch(friendsRepositoryProvider));
});

final sendFriendRequestProvider = Provider<SendFriendRequest>((ref) {
  return SendFriendRequest(ref.watch(friendsRepositoryProvider));
});

final acceptFriendRequestProvider = Provider<AcceptFriendRequest>((ref) {
  return AcceptFriendRequest(ref.watch(friendsRepositoryProvider));
});

final rejectFriendRequestProvider = Provider<RejectFriendRequest>((ref) {
  return RejectFriendRequest(ref.watch(friendsRepositoryProvider));
});

final getPendingRequestsProvider = Provider<GetPendingRequests>((ref) {
  return GetPendingRequests(ref.watch(friendsRepositoryProvider));
});

final removeFriendProvider = Provider<RemoveFriend>((ref) {
  return RemoveFriend(ref.watch(friendsRepositoryProvider));
});

// Controllers
final friendsControllerProvider =
StateNotifierProvider<FriendsController, FriendsState>((ref) {
  return FriendsController(getFriends: ref.watch(getFriendsProvider));
});

final searchUsersControllerProvider =
StateNotifierProvider<SearchUsersController, SearchUsersState>((ref) {
  return SearchUsersController(searchUsers: ref.watch(searchUsersProvider));
});

final friendRequestsControllerProvider =
StateNotifierProvider<FriendRequestsController, FriendRequestsState>((ref) {
  return FriendRequestsController(
      getPendingRequests: ref.watch(getPendingRequestsProvider));
});

// Helpers for actions
final sendFriendRequestAction = Provider<SendFriendRequest>((ref) {
  return ref.watch(sendFriendRequestProvider);
});

final acceptFriendRequestAction = Provider<AcceptFriendRequest>((ref) {
  return ref.watch(acceptFriendRequestProvider);
});

final rejectFriendRequestAction = Provider<RejectFriendRequest>((ref) {
  return ref.watch(rejectFriendRequestProvider);
});

final removeFriendAction = Provider<RemoveFriend>((ref) {
  return ref.watch(removeFriendProvider);
});