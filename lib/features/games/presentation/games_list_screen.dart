import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gamesync/features/games/presentation/widget/game_cards.dart';
import 'package:gamesync/features/games/presentation/widget/games_sort_dropdown.dart';

import '../../../core/result.dart';
import '../domain/game.dart';
import 'games_provider.dart';
import 'games_sort_provider.dart'; // Asegúrate de importar tu provider de ordenamiento

class GamesListScreen extends ConsumerWidget {
  static const routeName = '/games-list';

  const GamesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncGames = ref.watch(gamesListProvider);
    final sortedGames = ref.watch(sortedGamesProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Tus juegos'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Center(child: GamesSortDropdown()),
          ),
        ],
      ),
      body: asyncGames.when(
        data: (result) {
          if (result is Failure<List<Game>>) {
            return Center(child: Text(result.failure.message));
          }

          if (sortedGames.isEmpty) {
            return const Center(child: Text('No se encontraron juegos.'));
          }

          return ListView.builder(
            itemCount: sortedGames.length,
            itemBuilder: (context, index) {
              final game = sortedGames[index];
              return GameCard(game: game);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
