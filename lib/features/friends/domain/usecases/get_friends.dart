import 'package:dartz/dartz.dart';
import 'package:fitcoin/core/error/failures.dart';
import '../entities/friends_data.dart';
import '../repositories/friends_repository.dart';

class GetFriends {
  final FriendsRepository repository;
  GetFriends(this.repository);
  Future<Either<Failure, FriendsData>> call() => repository.getFriends();
}