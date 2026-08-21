import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitcoin/features/account/data/datasources/account_remote_source.dart';
import 'package:fitcoin/features/account/data/repositories/account_repository_impl.dart';
import 'package:fitcoin/features/account/domain/repositories/account_repository.dart';
import 'package:fitcoin/features/account/domain/usecases/deactivate_account.dart';

final accountRemoteSourceProvider = Provider<AccountRemoteSource>((ref) {
  return AccountRemoteSource();
});

final accountRepositoryProvider = Provider<AccountRepository>((ref) {
  return AccountRepositoryImpl(remoteSource: ref.watch(accountRemoteSourceProvider));
});

final deactivateAccountProvider = Provider<DeactivateAccount>((ref) {
  return DeactivateAccount(ref.watch(accountRepositoryProvider));
});