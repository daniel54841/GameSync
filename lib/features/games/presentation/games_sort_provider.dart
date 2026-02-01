import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/result.dart';
import '../domain/game.dart';
import 'games_provider.dart';

enum GamesSortType {
  hoursDesc,
  hoursAsc,
}

final gamesSortTypeProvider = StateProvider<GamesSortType>(
      (ref) => GamesSortType.hoursDesc,
);
final sortedGamesProvider = Provider<List<Game>>((ref) {
  final result = ref.watch(gamesListProvider).valueOrNull;
  final sortType = ref.watch(gamesSortTypeProvider);

  if (result is! Success<List<Game>>) return [];

  final games = [...result.value];

  switch (sortType) {
    case GamesSortType.hoursDesc:
      games.sort((a, b) => b.hoursPlayed.compareTo(a.hoursPlayed));
      break;
    case GamesSortType.hoursAsc:
      games.sort((a, b) => a.hoursPlayed.compareTo(b.hoursPlayed));
      break;
  }

  return games;
});
