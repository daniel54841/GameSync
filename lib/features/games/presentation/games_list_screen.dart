// lib/features/games/presentation/games_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamesync/features/games/presentation/widget/game_cards.dart';

import '../../../core/result.dart';
import '../domain/game.dart';
import 'games_provider.dart';

class GamesListScreen extends ConsumerWidget {
  static const routeName = '/games-list';

  const GamesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncGames = ref.watch(gamesListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tus juegos'),
      ),
      body: asyncGames.when(
        data: (result) {
          if (result is Failure<List<Game>>) {
            return Center(child: Text(result.failure.message));
          }
          final games = (result as Success<List<Game>>).value;
          if (games.isEmpty) {
            return const Center(child: Text('No se encontraron juegos.'));
          }
          return ListView.builder(
            itemCount: games.length,
            itemBuilder: (context, index) {
              final game = games[index];
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
