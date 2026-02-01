import 'package:dio/dio.dart';
import '../../domain/game.dart';
import '../../domain/game_platform.dart';
import 'games_datasource.dart';

class SteamGamesDataSource implements GamesDataSource {
  final Dio _dio;
  final String apiKey;
  final String steamId;

  SteamGamesDataSource({
    required Dio dio,
    required this.apiKey,
    required this.steamId,
  }) : _dio = dio;

  @override
  Future<List<Game>> fetchGames() async {
    // TODO: Sustituir por llamada real a Steam Web API:
    // IPlayerService/GetOwnedGames/v1
    // Aquí dejo un mock optimizado para que puedas probar la UI.
    await Future.delayed(const Duration(milliseconds: 300));

    return const [
      Game(
        id: '570',
        title: 'Dota 2',
        imageUrl: 'https://cdn.cloudflare.steamstatic.com/steam/apps/570/header.jpg',
        hoursPlayed: 123.4,
        platform: GamePlatform.steam,
      ),
      Game(
        id: '730',
        title: 'Counter-Strike 2',
        imageUrl: 'https://cdn.cloudflare.steamstatic.com/steam/apps/730/header.jpg',
        hoursPlayed: 456.7,
        platform: GamePlatform.steam,
      ),
    ];
  }
}
