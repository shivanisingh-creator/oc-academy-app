// lib/data/auth_api/token_storage.dart

import 'package:shared_preferences/shared_preferences.dart';
// Define a constant key for storing the token (Use a strong name)
const String _keyAccessToken = 'keycloak_access_token'; 

class TokenStorage {
  // 1. Save the token
  Future<void> saveAccessToken(String? token) async {
    if (token == null) return;
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyAccessToken, token);
      print("✅ Token saved to SharedPreferences.");
    } catch (e) {
      print("❌ Error saving token: $e");
    }
  }

  // 2. Retrieve the token
  Future<String?> getAccessToken() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString(_keyAccessToken);
    } catch (e) {
      print("❌ Error retrieving token: $e");
      return null;
    }
  }

  // 3. Delete the token (e.g., on logout)
  Future<void> deleteAccessToken() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyAccessToken);
      print("Token deleted.");
    } catch (e) {
      print("❌ Error deleting token: $e");
    }
  }
}