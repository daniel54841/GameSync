import '../../../../core/failures.dart';
import '../../../../core/result.dart';
import '../../domain/game.dart';
import '../../domain/game_platform.dart';
import '../../domain/games_repository.dart';
import '../datasources/games_datasource.dart';
import '../datasources/steam_games_datasources.dart';

class GamesRepositoryImpl implements GamesRepository {
  final Map<GamePlatform, GamesDataSource> _dataSources;
  final SteamGamesDataSource _steamDataSource;

  GamesRepositoryImpl(this._dataSources, this._steamDataSource);

  @override
  Future<Result<List<Game>>> getAllGames({
    required Set<GamePlatform> enabledPlatforms,
    String? steamId,
  }) async {
    try {
      final List<Future<Result<List<Game>>>> futures = [];

      for (final platform in enabledPlatforms) {
        if (platform == GamePlatform.steam) {
          if (steamId != null && steamId.isNotEmpty) {
            futures.add(_steamDataSource.fetchGames(steamId));
          }
        } else if (_dataSources.containsKey(platform)) {
          // Para otras plataformas que no necesitan IDs específicos aún
          futures.add(_wrapDataSource(_dataSources[platform]!));
        }
      }

      final results = await Future.wait(futures);
      
      final List<Game> allGames = [];
      for (final result in results) {
        if (result is Success<List<Game>>) {
          allGames.addAll(result.value);
        }
      }

      allGames.sort((a, b) => b.hoursPlayed.compareTo(a.hoursPlayed));

      return Success(allGames);
    } catch (e, st) {
      return Failure(AppFailure('Error obteniendo juegos', error: e, stackTrace: st));
    }
  }

  Future<Result<List<Game>>> _wrapDataSource(GamesDataSource ds) async {
    try {
      final games = await ds.fetchGames();
      return Success(games);
    } catch (e) {
      return Failure(AppFailure('Error en datasource', error: e));
    }
  }
}
