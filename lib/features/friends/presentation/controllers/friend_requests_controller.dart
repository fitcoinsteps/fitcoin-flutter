import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitcoin/features/friends/domain/entities/friend_request.dart';
import 'package:fitcoin/features/friends/domain/usecases/get_pending_requests.dart';
import 'package:fitcoin/features/friends/presentation/states/friends_states.dart';


class FriendRequestsController extends StateNotifier<FriendRequestsState> {
  final GetPendingRequests _getPendingRequests;

  FriendRequestsController({required GetPendingRequests getPendingRequests})
      : _getPendingRequests = getPendingRequests,
        super(FriendRequestsInitial());

  Future<void> loadRequests() async {
    state = FriendRequestsLoading();
    final result = await _getPendingRequests();
    result.fold(
          (failure) => state = FriendRequestsError(failure.message),
          (requests) => state = FriendRequestsLoaded(requests),
    );
  }
}