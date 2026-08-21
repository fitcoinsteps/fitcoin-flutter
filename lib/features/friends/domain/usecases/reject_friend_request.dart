import 'package:dartz/dartz.dart';
import 'package:fitcoin/core/error/failures.dart';
import '../repositories/friends_repository.dart';

class RejectFriendRequest {
  final FriendsRepository repository;
  RejectFriendRequest(this.repository);
  Future<Either<Failure, void>> call(int friendshipId) =>
      repository.rejectFriendRequest(friendshipId);
}