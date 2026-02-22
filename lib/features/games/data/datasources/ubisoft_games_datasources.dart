import '../../domain/game.dart';
import 'games_datasource.dart';

class UbisoftGamesDataSource implements GamesDataSource {
  @override
  Future<List<Game>> fetchGames() async {
    // TODO: Integrar con APIs internas de Ubisoft o backend.
    await Future.delayed(const Duration(milliseconds: 200));
    return const [
    ];
  }
}
