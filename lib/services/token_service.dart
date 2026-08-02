import 'package:shared_preferences/shared_preferences.dart';

class TokenService {

  static const String tokenKey = "jwt_token";

  // Save JWT
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenKey, token);
  }

  // Get JWT
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey);
  }

  // Delete JWT
  static Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(tokenKey);
  }

  // Check Login
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }
}