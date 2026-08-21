import 'package:dartz/dartz.dart';
import 'package:fitcoin/core/error/failures.dart';
import '../entities/friend_request.dart';
import '../repositories/friends_repository.dart';

class GetPendingRequests {
  final FriendsRepository repository;
  GetPendingRequests(this.repository);
  Future<Either<Failure, List<FriendRequest>>> call() =>
      repository.getPendingRequests();
}