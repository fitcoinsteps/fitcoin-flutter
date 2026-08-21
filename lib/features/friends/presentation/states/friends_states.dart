import 'package:fitcoin/features/friends/domain/entities/friends_data.dart';
import 'package:fitcoin/features/friends/domain/entities/search_user.dart';
import 'package:fitcoin/features/friends/domain/entities/friend_request.dart';

sealed class FriendsState {}

class FriendsInitial extends FriendsState {}

class FriendsLoading extends FriendsState {
  final FriendsData? cachedData;
  FriendsLoading({this.cachedData});
}

class FriendsLoaded extends FriendsState {
  final FriendsData data;
  FriendsLoaded(this.data);
}

class FriendsError extends FriendsState {
  final String message;
  FriendsError(this.message);
}

// Search states
sealed class SearchUsersState {}

class SearchUsersInitial extends SearchUsersState {}

class SearchUsersLoading extends SearchUsersState {}

class SearchUsersLoaded extends SearchUsersState {
  final List<SearchUser> users;
  SearchUsersLoaded(this.users);
}

class SearchUsersError extends SearchUsersState {
  final String message;
  SearchUsersError(this.message);
}

// Friend requests states
sealed class FriendRequestsState {}

class FriendRequestsInitial extends FriendRequestsState {}

class FriendRequestsLoading extends FriendRequestsState {}

class FriendRequestsLoaded extends FriendRequestsState {
  final List<FriendRequest> requests;
  FriendRequestsLoaded(this.requests);
}

class FriendRequestsError extends FriendRequestsState {
  final String message;
  FriendRequestsError(this.message);
}