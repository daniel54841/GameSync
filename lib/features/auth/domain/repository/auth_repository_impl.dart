// data/repositories/auth_repository_impl.dart
import 'package:gamesync/features/auth/data/steam_local_storage.dart';

import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final SteamLocalStorage localDataSource;
  AuthRepositoryImpl(this.localDataSource);

  @override
  Future<String?> getPersistedSteamId() => localDataSource.getSteamId();

  @override
  Future<void> persistSteamId(String uid) => localDataSource.saveSteamId(uid);
}