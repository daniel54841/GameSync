import 'game_platform.dart';

class Game {
  final String id;
  final String title;
  final String imageUrl;
  final double hoursPlayed;
  final GamePlatform platform;

  const Game({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.hoursPlayed,
    required this.platform,
  });
}
