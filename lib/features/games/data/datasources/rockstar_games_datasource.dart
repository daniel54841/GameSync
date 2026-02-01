// lib/features/games/data/datasources/rockstar_games_datasource.dart
import '../../domain/game.dart';
import '../../domain/game_platform.dart';
import 'games_datasource.dart';

class RockstarGamesDataSource implements GamesDataSource {
  @override
  Future<List<Game>> fetchGames() async {
    // TODO: Integrar con Social Club o backend propio.
    await Future.delayed(const Duration(milliseconds: 200));
    return const [

    ];
  }
}
