

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SteamLocalStorage {
  static const _steamIdKey = 'steam_id';

  final FlutterSecureStorage _storage;

  SteamLocalStorage(this._storage);

  Future<void> saveSteamId(String steamId) async {
    await _storage.write(key: _steamIdKey, value: steamId);
  }

  Future<String?> getSteamId() async {
    return _storage.read(key: _steamIdKey);
  }

  Future<void> clearSteamId() async {
    await _storage.delete(key: _steamIdKey);
  }
}
