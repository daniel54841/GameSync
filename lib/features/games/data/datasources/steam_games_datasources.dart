import 'package:dio/dio.dart';

import '../../../../core/failures.dart';
import '../../../../core/result.dart';
import '../../domain/game.dart';
import '../../domain/game_platform.dart';

// TODO: Mover a su propio archivo en /domain
class Achievement {
  final String apiName;
  final String displayName;
  final bool achieved;
  final String iconUrl;
  final String description;

  Achievement({
    required this.apiName,
    required this.displayName,
    required this.achieved,
    required this.iconUrl,
    required this.description,
  });
}

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

  Future<Result<List<Achievement>>> getGameAchievements({
    required String appId,
    required String steamId,
  }) async {
    try {
      if (steamId.isEmpty) {
        return Failure(AppFailure('No hay SteamID configurado'));
      }

      // 1. Obtener el esquema de logros para nombres, descripciones e iconos
      final schemaResponse = await _dio.get(
        'https://api.steampowered.com/ISteamUserStats/GetSchemaForGame/v2/',
        queryParameters: {'key': apiKey, 'appid': appId},
      );
      
      final gameData = schemaResponse.data['game'];
      if (gameData == null || 
          gameData['availableGameStats'] == null || 
          gameData['availableGameStats']['achievements'] == null) {
        return const Success([]); // El juego no tiene logros definidos
      }

      final schemaData = gameData['availableGameStats']['achievements'] as List;
      final schemaMap = {for (var item in schemaData) item['name']: item};

      // 2. Obtener el estado de los logros (si están desbloqueados o no)
      final playerResponse = await _dio.get(
        'https://api.steampowered.com/ISteamUserStats/GetUserStatsForGame/v2/',
        queryParameters: {
          'key': apiKey,
          'steamid': steamId,
          'appid': appId,
        },
      );

      final playerStats = playerResponse.data['playerstats'];
      if (playerStats == null || playerStats['success'] == false) {
        // A veces el esquema existe pero el usuario no tiene estadísticas aún
        return const Success([]); 
      }
      
      final achievementsJson = (playerStats['achievements'] as List?) ?? [];
      final playerAchievements = {for (var item in achievementsJson) item['name']: item['achieved'] == 1};

      // 3. Combinar ambos resultados
      final achievements = schemaMap.values.map<Achievement>((schema) {
        final apiName = schema['name'] as String;
        final achieved = playerAchievements[apiName] ?? false;
        return Achievement(
          apiName: apiName,
          displayName: schema['displayName'] as String? ?? 'Logro',
          achieved: achieved,
          iconUrl: schema['icon'] as String,
          description: schema['description'] as String? ?? '',
        );
      }).toList();

      return Success(achievements);
    } catch (e, st) {
      // Si falla por perfil privado (403), devolvemos un mensaje claro
      if (e is DioException && e.response?.statusCode == 403) {
        return Failure(AppFailure('Tu perfil de Steam es privado. Por favor, cámbialo a público para ver tus logros.'));
      }
      return Failure(AppFailure('Error obteniendo logros del juego', error: e, stackTrace: st));
    }
  }
}
