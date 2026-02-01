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

  bool _rememberId = false;        // Nuevo: switch para recordar ID
  String? _existingSteamId;        // Nuevo: saber si ya había uno guardado

  @override
  void initState() {
    super.initState();
    _loadExistingSteamId();
  }

  Future<void> _loadExistingSteamId() async {
    final storage = ref.read(steamLocalStorageProvider);
    final savedId = await storage.getSteamId();

    if (savedId != null && savedId.isNotEmpty) {
      setState(() {
        _existingSteamId = savedId;
        _controller.text = savedId;   // Rellenar automáticamente
        _rememberId = true;           // Si ya estaba guardado, marcar switch
      });
    }
  }

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
      final storage = ref.read(steamLocalStorageProvider);

      // Guardar solo si el usuario quiere recordarlo
      if (_rememberId) {
        await storage.saveSteamId(steamId);
      } else {
        await storage.clearSteamId();
      }

      if (!mounted) return;
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
    final isReturningUser = _existingSteamId != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Conectar Steam'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Introduce tu SteamID64.\nPuedes obtenerlo en páginas como steamid.io.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'SteamID64',
                border: const OutlineInputBorder(),
                errorText: _error,
              ),
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 16),

            // Mostrar switch solo si ya había un ID guardado
            if (isReturningUser)
              SwitchListTile(
                title: const Text("Recordar este SteamID"),
                value: _rememberId,
                onChanged: (value) {
                  setState(() => _rememberId = value);
                },
              ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _onSubmit,
                child: _isLoading
                    ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                    : const Text('Guardar y continuar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
