import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// SharedPreferencesManager for handling local data storage
class SharedPreferencesManager {
  SharedPreferencesManager._();

  static SharedPreferencesManager? _instance;
  static SharedPreferences? _prefs;

  static SharedPreferencesManager get instance {
    _instance ??= SharedPreferencesManager._();
    return _instance!;
  }

  // Initialize SharedPreferences
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static SharedPreferences get prefs {
    if (_prefs == null) {
      throw Exception(
        'SharedPreferences not initialized. Call SharedPreferencesManager.init() first.',
      );
    }
    return _prefs!;
  }

  // --- String Operations ---

  // Save a string value
  Future<bool> setString(String key, String value) async {
    try {
      return await prefs.setString(key, value);
    } catch (e) {
      throw SharedPreferencesException('Failed to save string: $e');
    }
  }

  // Get a string value
  String? getString(String key) {
    try {
      return prefs.getString(key);
    } catch (e) {
      throw SharedPreferencesException('Failed to get string: $e');
    }
  }

  // --- JSON Operations ---

  // Save a JSON serializable object
  Future<bool> setJson(String key, Map<String, dynamic> value) async {
    try {
      final jsonString = jsonEncode(value);
      return await setString(key, jsonString);
    } catch (e) {
      throw SharedPreferencesException('Failed to save JSON: $e');
    }
  }

  // Get a JSON object
  Map<String, dynamic>? getJson(String key) {
    try {
      final jsonString = getString(key);
      if (jsonString == null) return null;
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      throw SharedPreferencesException('Failed to get JSON: $e');
    }
  }

  // Get a JSON object with default
  Map<String, dynamic> getJsonOrDefault(
    String key,
    Map<String, dynamic> defaultValue,
  ) {
    return getJson(key) ?? defaultValue;
  }
}

class SharedPreferencesException implements Exception {
  final String message;

  const SharedPreferencesException(this.message);

  @override
  String toString() => 'SharedPreferencesException: $message';
}

/// Predefined keys for the application
class PreferenceKeys {
  PreferenceKeys._();

  // Coin portfolio
  static const String coinPortfolio = 'coin_portfolio';
}
