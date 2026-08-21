import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitcoin/features/profile/domain/entities/user_profile.dart';
import 'package:fitcoin/features/profile/domain/usecases/get_profile.dart';
import 'package:fitcoin/features/profile/domain/usecases/update_profile.dart';
import 'package:fitcoin/features/profile/domain/usecases/upload_avatar.dart';
import 'package:fitcoin/features/profile/presentation/states/profile_states.dart';

class ProfileController extends StateNotifier<ProfileState> {
  final GetProfile _getProfile;
  final UpdateProfile _updateProfile;
  final UploadAvatar _uploadAvatar;

  UserProfile? _lastProfile;

  ProfileController({
    required GetProfile getProfile,
    required UpdateProfile updateProfile,
    required UploadAvatar uploadAvatar,
  })  : _getProfile = getProfile,
        _updateProfile = updateProfile,
        _uploadAvatar = uploadAvatar,
        super(ProfileInitial());

  Future<void> loadProfile() async {
    state = ProfileLoading(cachedProfile: _lastProfile);
    final result = await _getProfile();
    result.fold(
          (failure) => state = ProfileError(failure.message),
          (profile) {
        _lastProfile = profile;
        state = ProfileLoaded(profile);
      },
    );
  }

  Future<void> updateProfile({
    String? firstName,
    String? lastName,
    String? username,
    String? phone,
  }) async {
    state = ProfileLoading(cachedProfile: _lastProfile);
    final result = await _updateProfile(
      firstName: firstName,
      lastName: lastName,
      username: username,
      phone: phone,
    );
    result.fold(
          (failure) => state = ProfileError(failure.message),
          (profile) {
        _lastProfile = profile;
        state = ProfileLoaded(profile);
      },
    );
  }

  Future<void> uploadAvatar(String filePath) async {
    state = ProfileLoading(cachedProfile: _lastProfile);
    final result = await _uploadAvatar(filePath);
    result.fold(
          (failure) => state = ProfileError(failure.message),
          (profile) {
        _lastProfile = profile;
        state = ProfileLoaded(profile);
      },
    );
  }
}