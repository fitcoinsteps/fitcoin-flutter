import 'package:dartz/dartz.dart';
import 'package:fitcoin/core/error/failures.dart';
import '../entities/friends_data.dart';
import '../entities/search_user.dart';
import '../entities/friend_request.dart';

abstract class FriendsRepository {
  Future<Either<Failure, FriendsData>> getFriends();
  Future<Either<Failure, List<SearchUser>>> searchUsers(String query);
  Future<Either<Failure, void>> sendFriendRequest(int receiverId);
  Future<Either<Failure, void>> acceptFriendRequest(int friendshipId);
  Future<Either<Failure, void>> rejectFriendRequest(int friendshipId);
  Future<Either<Failure, List<FriendRequest>>> getPendingRequests();
  Future<Either<Failure, void>> removeFriend(int friendId);
}