import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static SharedPreferences? _prefs;

  /// Initialize the SharedPreferences instance
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Save String
  static Future<bool> saveString(String key, String value) async {
    return await _prefs!.setString(key, value);
  }

  // Get String
  static String? getString(String key) {
    return _prefs!.getString(key);
  }

  // Save Bool
  static Future<bool> saveBool(String key, bool value) async {
    return await _prefs!.setBool(key, value);
  }

  // Get Bool
  static bool? getBool(String key) {
    return _prefs!.getBool(key);
  }

  // Save Int
  static Future<bool> saveInt(String key, int value) async {
    return await _prefs!.setInt(key, value);
  }

  // Get Int
  static int? getInt(String key) {
    return _prefs!.getInt(key);
  }

  // Save Double
  static Future<bool> saveDouble(String key, double value) async {
    return await _prefs!.setDouble(key, value);
  }

  // Get Double
  static double? getDouble(String key) {
    return _prefs!.getDouble(key);
  }

  // Remove Key
  static Future<bool> remove(String key) async {
    return await _prefs!.remove(key);
  }

  // Clear all
  static Future<bool> clear() async {
    return await _prefs!.clear();
  }
}
