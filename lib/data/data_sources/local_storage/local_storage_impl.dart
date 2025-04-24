import 'package:shared_preferences/shared_preferences.dart';
import 'local_storage.dart';

class LocalStorageImpl implements LocalStorage {
  final SharedPreferences prefs;

  LocalStorageImpl(this.prefs);

  @override
  Future<void> setString(String key, String value) async {
    await prefs.setString(key, value);
  }

  @override
  String? getString(String key) {
    return prefs.getString(key);
  }

  @override
  Future<bool> remove(String key) async {
    return prefs.remove(key);
  }
}
