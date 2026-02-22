// lib/features/games/data/datasources/steam_games_datasource.dart
import 'package:dio/dio.dart';

import '../../../../core/failures.dart';
import '../../../../core/result.dart';
import '../../domain/game.dart';
import '../../domain/game_platform.dart';

class SteamGamesDataSource {
  final Dio _dio;
  final String apiKey;

  SteamGamesDataSource({
    required Dio dio,
    required this.apiKey,
  }) : _dio = dio;

  Future<Result<List<Game>>> fetchGames(String steamId) async {
    try {
      if (steamId.isEmpty) {
        return Failure(AppFailure('No hay SteamID configurado'));
      }

      final response = await _dio.get(
        'https://api.steampowered.com/IPlayerService/GetOwnedGames/v1/',
        queryParameters: {
          'key': apiKey,
          'steamid': steamId,
          'include_appinfo': true,
          'include_played_free_games': true,
        },
      );

      final data = response.data as Map<String, dynamic>;
      final responseData = data['response'] as Map<String, dynamic>;
      final gamesJson = (responseData['games'] as List?) ?? [];

      final games = gamesJson.map<Game>((g) {
        final appId = g['appid'].toString();
        final name = g['name'] as String? ?? 'Juego $appId';
        final playtimeMinutes = (g['playtime_forever'] ?? 0) as int;
        final hours = playtimeMinutes / 60.0;

        final imageUrl =
            'https://cdn.cloudflare.steamstatic.com/steam/apps/$appId/header.jpg';

        return Game(
          id: appId,
          title: name,
          imageUrl: imageUrl,
          hoursPlayed: hours,
          platform: GamePlatform.steam,
        );
      }).toList()
        ..sort((a, b) => b.hoursPlayed.compareTo(a.hoursPlayed));

      return Success(games);
    } catch (e, st) {
      return Failure(AppFailure('Error obteniendo juegos de Steam', error: e, stackTrace: st));
    }
  }
}
