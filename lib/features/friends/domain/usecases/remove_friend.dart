import 'package:dartz/dartz.dart';
import 'package:fitcoin/core/error/failures.dart';
import '../repositories/friends_repository.dart';

class RemoveFriend {
  final FriendsRepository repository;
  RemoveFriend(this.repository);
  Future<Either<Failure, void>> call(int friendId) =>
      repository.removeFriend(friendId);
}