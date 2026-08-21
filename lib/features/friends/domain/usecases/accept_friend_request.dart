import 'package:dartz/dartz.dart';
import 'package:fitcoin/core/error/failures.dart';
import '../repositories/friends_repository.dart';

class AcceptFriendRequest {
  final FriendsRepository repository;
  AcceptFriendRequest(this.repository);
  Future<Either<Failure, void>> call(int friendshipId) =>
      repository.acceptFriendRequest(friendshipId);
}