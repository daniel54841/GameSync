// lib/features/games/presentation/games_providers.dart

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import '../../../core/result.dart';
import '../../auth/presentation/auth_providers.dart';
import '../../auth/data/steam_local_storage.dart';

import '../data/datasources/games_datasource.dart';
import '../data/datasources/steam_games_datasources.dart';
import '../data/datasources/ubisoft_games_datasources.dart';
import '../domain/game.dart';
import '../domain/game_platform.dart';
import '../domain/games_repository.dart';

import '../data/datasources/epic_games_datasource.dart';
import '../data/datasources/rockstar_games_datasource.dart';

import '../data/repositories/games_repository_impl.dart';

// ------------------------------------------------------------
// 1. Provider de Dio
// ------------------------------------------------------------
final dioProvider = Provider<Dio>((ref) {
  return Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
    ),
  );
});

// ------------------------------------------------------------
// 2. Provider del DataSource REAL de Steam
// ------------------------------------------------------------


final steamGamesDataSourceProvider = Provider<SteamGamesDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  final storage = ref.watch(steamLocalStorageProvider);
  final apiKey = dotenv.env['STEAM_API_KEY'] ?? '';
  return SteamGamesDataSource(dio: dio, storage: storage, apiKey: apiKey);
});

// ------------------------------------------------------------
// 3. Adaptador para que SteamGamesDataSource encaje en GamesDataSource
// ------------------------------------------------------------
class _SteamDataSourceAdapter implements GamesDataSource {
  final SteamGamesDataSource _inner;

  _SteamDataSourceAdapter(this._inner);

  @override
  Future<List<Game>> fetchGames() async {
    final result = await _inner.fetchGames();
    if (result is Success<List<Game>>) return result.value;
    return [];
  }
}

// ------------------------------------------------------------
// 4. Provider del repositorio de juegos
// ------------------------------------------------------------
final gamesRepositoryProvider = Provider<GamesRepository>((ref) {
  final steamDs = ref.watch(steamGamesDataSourceProvider);
  return GamesRepositoryImpl({
    GamePlatform.steam: _SteamDataSourceAdapter(steamDs),
    GamePlatform.epic: EpicGamesDataSource(),
    GamePlatform.rockstar: RockstarGamesDataSource(),
    GamePlatform.ubisoft: UbisoftGamesDataSource(),
  });
});

// ------------------------------------------------------------ //
// 5. Provider de plataformas activadas
// ------------------------------------------------------------
final enabledPlatformsProvider = StateProvider<Set<GamePlatform>>(
  (ref) => {
    GamePlatform.steam,
    GamePlatform.epic,
    GamePlatform.rockstar,
    GamePlatform.ubisoft,
  },
);
// ------------------------------------------------------------
// 6. Provider que obtiene la lista de juegos
// ------------------------------------------------------------
final gamesListProvider = FutureProvider.autoDispose<Result<List<Game>>>((
  ref,
) async {
  final repo = ref.watch(gamesRepositoryProvider);
  final enabled = ref.watch(enabledPlatformsProvider);
  return repo.getAllGames(enabledPlatforms: enabled);
});
