// lib/features/games/presentation/games_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import '../../../core/result.dart';
import '../data/datasources/steam_games_datasources.dart';
import '../data/datasources/ubisoft_games_datasources.dart';
import '../domain/game.dart';
import '../domain/game_platform.dart';
import '../domain/games_repository.dart';
import '../data/datasources/epic_games_datasource.dart';
import '../data/datasources/rockstar_games_datasource.dart';
import '../data/repositories/games_repository_impl.dart';

final dioProvider = Provider<Dio>((ref) {
  return Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 5),
  ));
});

final gamesRepositoryProvider = Provider<GamesRepository>((ref) {
  final dio = ref.watch(dioProvider);

  // TODO: sustituir apiKey y steamId por valores reales o gestionados por auth.
  const steamApiKey = 'YOUR_STEAM_API_KEY';
  const steamId = 'YOUR_STEAM_ID';

  return GamesRepositoryImpl({
    GamePlatform.steam: SteamGamesDataSource(
      dio: dio,
      apiKey: steamApiKey,
      steamId: steamId,
    ),
    GamePlatform.epic: EpicGamesDataSource(),
    GamePlatform.rockstar: RockstarGamesDataSource(),
    GamePlatform.ubisoft: UbisoftGamesDataSource(),
  });
});

final enabledPlatformsProvider =
StateProvider<Set<GamePlatform>>((ref) => {
  GamePlatform.steam,
  GamePlatform.epic,
  GamePlatform.rockstar,
  GamePlatform.ubisoft,
});

final gamesListProvider =
FutureProvider.autoDispose<Result<List<Game>>>((ref) async {
  final repo = ref.watch(gamesRepositoryProvider);
  final enabled = ref.watch(enabledPlatformsProvider);
  return repo.getAllGames(enabledPlatforms: enabled);
});
