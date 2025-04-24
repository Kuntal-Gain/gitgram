abstract class LocalStorage {
  Future<void> setString(String key, String value);
  String? getString(String key);
  Future<bool> remove(String key);
  // Add more as needed
}
