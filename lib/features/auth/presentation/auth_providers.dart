// lib/features/auth/presentation/auth_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../data/steam_local_storage.dart';
import '../domain/repository/auth_repository.dart';
import '../domain/repository/auth_repository_impl.dart';

// Proveedores de dependencias
final storageProvider = Provider((ref) => const FlutterSecureStorage());

final authDataSourceProvider = Provider((ref) {
  return SteamLocalStorage(ref.watch(storageProvider));
});

final authRepositoryProvider = Provider((ref) {
  return AuthRepositoryImpl(ref.watch(authDataSourceProvider));
});

// El Notifier que controla el estado
class SteamIdNotifier extends StateNotifier<AsyncValue<String>> {
  final AuthRepository repository;

  SteamIdNotifier(this.repository) : super(const AsyncValue.loading()) {
    loadId();
  }

  Future<void> loadId() async {
    final id = await repository.getPersistedSteamId();
    state = AsyncValue.data(id ?? "");
  }

  Future<void> updateId(String newId) async {
    await repository.persistSteamId(newId);
    state = AsyncValue.data(newId);
  }
}

final steamIdProvider = StateNotifierProvider<SteamIdNotifier, AsyncValue<String>>((ref) {
  return SteamIdNotifier(ref.watch(authRepositoryProvider));
});



final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

final steamLocalStorageProvider = Provider<SteamLocalStorage>((ref) {
  final storage = ref.watch(secureStorageProvider);
  return SteamLocalStorage(storage);
});
