import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../games/presentation/games_list_screen.dart';
import '../auth_providers.dart';

class SteamLoginScreen extends ConsumerStatefulWidget {
  static const routeName = '/steam-login';

  const SteamLoginScreen({super.key});

  @override
  ConsumerState<SteamLoginScreen> createState() => _SteamLoginScreenState();
}

class _SteamLoginScreenState extends ConsumerState<SteamLoginScreen> {
  final _controller = TextEditingController();
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    final steamId = _controller.text.trim();
    if (steamId.isEmpty) {
      setState(() => _error = 'Introduce tu SteamID64');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Guardamos el SteamID en el almacenamiento persistente
      await ref.read(steamIdProvider.notifier).updateId(steamId);

      if (!mounted) return;
      // Navegamos a la lista de juegos ahora que el ID está guardado
      Navigator.of(context).pushReplacementNamed(GamesListScreen.routeName);
    } catch (e) {
      setState(() => _error = 'Error guardando SteamID');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final steamIdAsync = ref.watch(steamIdProvider);

    // Escuchar cambios para auto-rellenar si es necesario
    ref.listen<AsyncValue<String>>(steamIdProvider, (previous, next) {
      next.whenData((value) {
        if (_controller.text.isEmpty && value.isNotEmpty) {
          _controller.text = value;
        }
      });
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sincronizar con Steam'),
      ),
      body: steamIdAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (savedId) {
          // Si ya hay un ID guardado y el campo está vacío, lo ponemos por defecto
          if (_controller.text.isEmpty && savedId.isNotEmpty) {
            _controller.text = savedId;
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Introduce tu SteamID64.\nPuedes encontrarlo en la URL de tu perfil de Steam.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    labelText: 'SteamID64',
                    hintText: 'Ej: 76561198000000000',
                    border: const OutlineInputBorder(),
                    errorText: _error,
                    prefixIcon: const Icon(Icons.person),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _onSubmit,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Guardar y continuar'),
                  ),
                ),
                if (savedId.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(
                      'ID actual: $savedId',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
