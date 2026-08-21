import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitcoin/features/friends/domain/entities/friends_data.dart';
import 'package:fitcoin/features/friends/domain/usecases/get_friends.dart';
import 'package:fitcoin/features/friends/presentation/states/friends_states.dart';

class FriendsController extends StateNotifier<FriendsState> {
  final GetFriends _getFriends;

  FriendsData? _cachedData;

  FriendsController({required GetFriends getFriends})
      : _getFriends = getFriends,
        super(FriendsInitial());

  Future<void> loadFriends() async {
    state = FriendsLoading(cachedData: _cachedData);
    final result = await _getFriends();
    result.fold(
          (failure) => state = FriendsError(failure.message),
          (data) {
        _cachedData = data;
        state = FriendsLoaded(data);
      },
    );
  }
}