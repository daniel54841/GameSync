// domain/repositories/auth_repository.dart
abstract class AuthRepository {
  Future<void> persistSteamId(String uid);
  Future<String?> getPersistedSteamId();
}

// domain/use_cases/get_steam_id_use_case.dart
class GetSteamIdUseCase {
  final AuthRepository repository;
  GetSteamIdUseCase(this.repository);

  Future<String?> execute() => repository.getPersistedSteamId();
}

// domain/use_cases/save_steam_id_use_case.dart
class SaveSteamIdUseCase {
  final AuthRepository repository;
  SaveSteamIdUseCase(this.repository);

  Future<void> execute(String uid) => repository.persistSteamId(uid);
}