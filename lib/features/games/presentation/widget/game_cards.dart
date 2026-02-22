// lib/features/games/presentation/widgets/game_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamesync/features/games/presentation/achievements/achievements_screen.dart';
import '../../domain/game.dart';

class GameCard extends ConsumerWidget {
  final Game game;

  const GameCard({super.key, required this.game});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      color: Colors.black,
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () {
          // Navegar a la pantalla de logros
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => AchievementsScreen(game: game),
            ),
          );
        },
        child: SizedBox(
          height: 110,
          child: Row(
            children: [
              _GameImage(imageUrl: game.imageUrl),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        game.title,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${game.hoursPlayed.toStringAsFixed(1)} h jugadas',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GameImage extends StatelessWidget {
  final String imageUrl;

  const _GameImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      width: screenWidth * 0.4, // Aproximadamente 40% del ancho
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          color: Colors.grey.shade800,
          child: const Icon(Icons.videogame_asset, size: 32),
        ),
      ),
    );
  }
}
