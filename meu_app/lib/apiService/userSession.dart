import 'package:shared_preferences/shared_preferences.dart';

class UserSession {
  static const String ktoken = 'user_token';
  static const String kUserName = 'user_username';

  static Future<void> saveSession({
    required String token,
    required String userName,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(ktoken, token);
    await prefs.setString(kUserName, userName);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(ktoken);
  }

  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(kUserName);
  }

  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(ktoken);
    await prefs.remove(kUserName);
  }
}
