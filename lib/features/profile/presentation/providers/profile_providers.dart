import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitcoin/features/profile/data/datasources/profile_remote_source.dart';
import 'package:fitcoin/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:fitcoin/features/profile/domain/repositories/profile_repository.dart';
import 'package:fitcoin/features/profile/domain/usecases/get_profile.dart';
import 'package:fitcoin/features/profile/domain/usecases/update_profile.dart';
import 'package:fitcoin/features/profile/domain/usecases/upload_avatar.dart';
import 'package:fitcoin/features/profile/presentation/controllers/profile_controller.dart';
import 'package:fitcoin/features/profile/presentation/states/profile_states.dart';

final profileRemoteSourceProvider = Provider<ProfileRemoteSource>((ref) {
  return ProfileRemoteSource();
});

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepositoryImpl(remoteSource: ref.watch(profileRemoteSourceProvider));
});

final getProfileProvider = Provider<GetProfile>((ref) {
  return GetProfile(ref.watch(profileRepositoryProvider));
});

final updateProfileProvider = Provider<UpdateProfile>((ref) {
  return UpdateProfile(ref.watch(profileRepositoryProvider));
});

final uploadAvatarProvider = Provider<UploadAvatar>((ref) {
  return UploadAvatar(ref.watch(profileRepositoryProvider));
});

final profileControllerProvider =
StateNotifierProvider<ProfileController, ProfileState>((ref) {
  return ProfileController(
    getProfile: ref.watch(getProfileProvider),
    updateProfile: ref.watch(updateProfileProvider),
    uploadAvatar: ref.watch(uploadAvatarProvider),
  );
});