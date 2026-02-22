import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/result.dart';
import '../../data/datasources/steam_games_datasources.dart';
import '../../domain/game.dart';
import '../games_provider.dart';

class AchievementsScreen extends ConsumerWidget {
  final Game game;

  const AchievementsScreen({super.key, required this.game});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final achievementsAsync = ref.watch(gameAchievementsProvider(game.id));

    return Scaffold(
      appBar: AppBar(
        title: Text('Logros: ${game.title}'),
      ),
      body: achievementsAsync.when(
        data: (result) {
          if (result is Failure<List<Achievement>>) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  result.failure.message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.redAccent),
                ),
              ),
            );
          }

          final achievements = (result as Success<List<Achievement>>).value;

          if (achievements.isEmpty) {
            return const Center(child: Text('Este juego no tiene logros.'));
          }

          final completedCount = achievements.where((a) => a.achieved).length;

          return Column(
            children: [
              // Barra de progreso de logros
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.grey.withOpacity(0.1),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Progreso total', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('$completedCount / ${achievements.length}'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: completedCount / achievements.length,
                      backgroundColor: Colors.grey.shade800,
                      color: Colors.blue,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(8),
                  itemCount: achievements.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final achievement = achievements[index];
                    return ListTile(
                      leading: Opacity(
                        opacity: achievement.achieved ? 1.0 : 0.3,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.network(
                            achievement.iconUrl,
                            width: 48,
                            height: 48,
                            errorBuilder: (_, __, ___) => const Icon(Icons.star_border, size: 48),
                          ),
                        ),
                      ),
                      title: Text(
                        achievement.displayName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: achievement.achieved ? Colors.white : Colors.grey,
                        ),
                      ),
                      subtitle: Text(
                        achievement.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: achievement.achieved ? Colors.grey : Colors.grey.shade700,
                        ),
                      ),
                      trailing: achievement.achieved
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : const Icon(Icons.lock_outline, color: Colors.grey),
                    );
                  },
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
