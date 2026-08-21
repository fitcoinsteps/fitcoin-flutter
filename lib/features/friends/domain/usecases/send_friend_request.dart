import 'package:dartz/dartz.dart';
import 'package:fitcoin/core/error/failures.dart';
import '../repositories/friends_repository.dart';

class SendFriendRequest {
  final FriendsRepository repository;
  SendFriendRequest(this.repository);
  Future<Either<Failure, void>> call(int receiverId) =>
      repository.sendFriendRequest(receiverId);
}