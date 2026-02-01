// lib/features/auth/presentation/auth_selection_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamesync/features/auth/presentation/steam/steam_login_screen.dart';

import '../../games/domain/game_platform.dart';
import '../../games/presentation/games_list_screen.dart';
import '../../games/presentation/games_provider.dart';

class AuthSelectionScreen extends ConsumerWidget {
  static const routeName = '/auth-selection';

  const AuthSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enabledPlatforms = ref.watch(enabledPlatformsProvider);

    void togglePlatform(GamePlatform platform) {
      final current = ref.read(enabledPlatformsProvider.notifier);
      final set = {...current.state};
      if (set.contains(platform)) {
        set.remove(platform);
      } else {
        set.add(platform);
      }
      current.state = set;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Conectar plataformas'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _PlatformTile(
            label: 'Steam',
            platform: GamePlatform.steam,
            enabled: enabledPlatforms.contains(GamePlatform.steam),
            onChanged: () => togglePlatform(GamePlatform.steam),
          ),
          /*_PlatformTile(
            label: 'Epic Games',
            platform: GamePlatform.epic,
            enabled: enabledPlatforms.contains(GamePlatform.epic),
            onChanged: () => togglePlatform(GamePlatform.epic),
          ),
          _PlatformTile(
            label: 'Rockstar',
            platform: GamePlatform.rockstar,
            enabled: enabledPlatforms.contains(GamePlatform.rockstar),
            onChanged: () => togglePlatform(GamePlatform.rockstar),
          ),
          _PlatformTile(
            label: 'Ubisoft',
            platform: GamePlatform.ubisoft,
            enabled: enabledPlatforms.contains(GamePlatform.ubisoft),
            onChanged: () => togglePlatform(GamePlatform.ubisoft),
          ),*/
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: enabledPlatforms.isEmpty
                ? null
                : () {
              Navigator.of(context)
                  .pushReplacementNamed(SteamLoginScreen.routeName);
            },
            icon: const Icon(Icons.arrow_forward),
            label: const Text('Continuar'),
          ),
        ],
      ),
    );
  }
}

class _PlatformTile extends StatelessWidget {
  final String label;
  final GamePlatform platform;
  final bool enabled;
  final VoidCallback onChanged;

  const _PlatformTile({
    required this.label,
    required this.platform,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(label),
      value: enabled,
      onChanged: (_) => onChanged(),
      secondary: Icon(_iconForPlatform(platform)),
    );
  }

  IconData _iconForPlatform(GamePlatform platform) {
    switch (platform) {
      case GamePlatform.steam:
        return Icons.cloud;
      case GamePlatform.epic:
        return Icons.gamepad;
      case GamePlatform.rockstar:
        return Icons.star;
      case GamePlatform.ubisoft:
        return Icons.shield;
    }
  }
}
