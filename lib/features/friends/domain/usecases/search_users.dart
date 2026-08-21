import 'package:dartz/dartz.dart';
import 'package:fitcoin/core/error/failures.dart';
import '../entities/search_user.dart';
import '../repositories/friends_repository.dart';

class SearchUsers {
  final FriendsRepository repository;
  SearchUsers(this.repository);
  Future<Either<Failure, List<SearchUser>>> call(String query) =>
      repository.searchUsers(query);
}