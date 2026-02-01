import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamesync/features/auth/presentation/steam/steam_login_screen.dart';

import 'features/auth/presentation/auth_selection_screen.dart';
import 'features/games/presentation/games_list_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Cargar variables del archivo .env
  await dotenv.load(fileName: ".env");
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Game Sync',
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      initialRoute: AuthSelectionScreen.routeName,
      routes: {
        AuthSelectionScreen.routeName: (_) => const AuthSelectionScreen(),
        GamesListScreen.routeName: (_) => const GamesListScreen(),
        SteamLoginScreen.routeName: (_) => const SteamLoginScreen(),
      },
    );
  }
}
