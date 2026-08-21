import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitcoin/features/friends/domain/entities/search_user.dart';
import 'package:fitcoin/features/friends/domain/usecases/search_users.dart';
import 'package:fitcoin/features/friends/presentation/states/friends_states.dart';


class SearchUsersController extends StateNotifier<SearchUsersState> {
  final SearchUsers _searchUsers;

  SearchUsersController({required SearchUsers searchUsers})
      : _searchUsers = searchUsers,
        super(SearchUsersInitial());

  Future<void> search(String query) async {
    state = SearchUsersLoading();
    final result = await _searchUsers(query);
    result.fold(
          (failure) => state = SearchUsersError(failure.message),
          (users) => state = SearchUsersLoaded(users),
    );
  }
}