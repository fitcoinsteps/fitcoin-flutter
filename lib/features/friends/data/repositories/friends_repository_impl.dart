import 'package:dartz/dartz.dart';
import 'package:fitcoin/core/error/failures.dart';
import 'package:fitcoin/features/friends/domain/entities/friends_data.dart';
import 'package:fitcoin/features/friends/domain/entities/search_user.dart';
import 'package:fitcoin/features/friends/domain/entities/friend_request.dart';
import 'package:fitcoin/features/friends/domain/repositories/friends_repository.dart';
import '../datasources/friends_remote_source.dart';

class FriendsRepositoryImpl implements FriendsRepository {
  final FriendsRemoteSource remoteSource;

  FriendsRepositoryImpl({required this.remoteSource});

  @override
  Future<Either<Failure, FriendsData>> getFriends() async {
    try {
      final data = await remoteSource.getFriends();
      return Right(data);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<SearchUser>>> searchUsers(String query) async {
    try {
      final users = await remoteSource.searchUsers(query);
      return Right(users);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> sendFriendRequest(int receiverId) async {
    try {
      await remoteSource.sendFriendRequest(receiverId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> acceptFriendRequest(int friendshipId) async {
    try {
      await remoteSource.acceptFriendRequest(friendshipId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> rejectFriendRequest(int friendshipId) async {
    try {
      await remoteSource.rejectFriendRequest(friendshipId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<FriendRequest>>> getPendingRequests() async {
    try {
      final requests = await remoteSource.getPendingRequests();
      return Right(requests);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeFriend(int friendId) async {
    try {
      await remoteSource.removeFriend(friendId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}