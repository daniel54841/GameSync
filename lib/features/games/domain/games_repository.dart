import '../../../core/result.dart';
import 'game.dart';
import 'game_platform.dart';

abstract class GamesRepository {
  Future<Result<List<Game>>> getAllGames({
    required Set<GamePlatform> enabledPlatforms,
    String? steamId,
  });
}
