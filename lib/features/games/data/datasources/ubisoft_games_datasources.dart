// lib/features/games/data/datasources/ubisoft_games_datasource.dart
import '../../domain/game.dart';
import '../../domain/game_platform.dart';
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
