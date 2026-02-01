import '../../../../core/failures.dart';
import '../../../../core/result.dart';
import '../../domain/game.dart';
import '../../domain/game_platform.dart';
import '../../domain/games_repository.dart';
import '../datasources/games_datasource.dart';

class GamesRepositoryImpl implements GamesRepository {
  final Map<GamePlatform, GamesDataSource> _dataSources;

  GamesRepositoryImpl(this._dataSources);

  @override
  Future<Result<List<Game>>> getAllGames({
    required Set<GamePlatform> enabledPlatforms,
  }) async {
    try {
      final futures = enabledPlatforms
          .where(_dataSources.containsKey)
          .map((platform) => _dataSources[platform]!.fetchGames());

      final results = await Future.wait(futures);
      final allGames = results.expand((g) => g).toList()
        ..sort((a, b) => a.title.compareTo(b.title));

      return Success(allGames);
    } catch (e, st) {
      return Failure(AppFailure('Error obteniendo juegos', error: e, stackTrace: st));
    }
  }
}

