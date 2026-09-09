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

  static const String _kSeguidos = 'seguidos_set_';

  static Future<Set<String>> getPerfisSeguidos(String myLogin) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('$_kSeguidos$myLogin') ?? [];
    return list.toSet();
  }

  static Future<void> salvarPerfisSeguidos(
    String myLogin,
    Set<String> seguidos,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('$_kSeguidos$myLogin', seguidos.toList());
  }

  static Future<void> adicionarSeguido(String myLogin, String login) async {
    if (myLogin.isEmpty || login.isEmpty) return;
    final seguidos = await getPerfisSeguidos(myLogin);
    seguidos.add(login);
    await salvarPerfisSeguidos(myLogin, seguidos);
  }

  static Future<void> removerSeguido(String myLogin, String login) async {
    if (myLogin.isEmpty || login.isEmpty) return;
    final seguidos = await getPerfisSeguidos(myLogin);
    seguidos.remove(login);
    await salvarPerfisSeguidos(myLogin, seguidos);
  }
}

