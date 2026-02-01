// lib/features/auth/presentation/auth_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../data/steam_local_storage.dart';

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

final steamLocalStorageProvider = Provider<SteamLocalStorage>((ref) {
  final storage = ref.watch(secureStorageProvider);
  return SteamLocalStorage(storage);
});
