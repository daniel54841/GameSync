import '../../domain/game.dart';
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
