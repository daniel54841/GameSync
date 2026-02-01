import '../../domain/game.dart';

abstract class GamesDataSource {
  Future<List<Game>> fetchGames();
}
