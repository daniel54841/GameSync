// lib/features/games/data/datasources/epic_games_datasource.dart
import '../../domain/game.dart';
import '../../domain/game_platform.dart';
import 'games_datasource.dart';

class EpicGamesDataSource implements GamesDataSource {
  @override
  Future<List<Game>> fetchGames() async {
    // TODO: Integrar con Epic Online Services o tu backend.
    await Future.delayed(const Duration(milliseconds: 200));
    return const [];
  }
}
