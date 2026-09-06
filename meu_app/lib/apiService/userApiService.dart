import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:meu_app/models/UserMo.dart';

class UserApiService {
  final String url = 'https://api.papacapim.just.pro.br';

  Future<String> getUser({required String login, required String senha}) async {
    final http.Client client = http.Client();
    final _url = Uri.parse('$url/sessions');

    try {
      final res = await client.post(
        _url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'login': login, 'password': senha}),
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        final data = jsonDecode(res.body);
        return data['token'] ?? res.headers['x-session-token'];
      } else {
        throw Exception('Falha no login ${res.statusCode} : ${res.body}');
      }
    } finally {
      client.close();
    }
  }

  Future<Set<String>> getUsuariosSeguidos({required String token}) async {
    final http.Client client = http.Client();
    try {
      final res = await client.get(
        Uri.parse('$url/users'),
        headers: {'x-session-token': token, 'Content-Type': 'application/json'},
      );
      if (res.statusCode == 200) {
        final List<dynamic> users = jsonDecode(res.body);
        // Retorna o conjunto dos logins que você segue (you_follow == true)
        return users
            .where((usuario) => usuario['you_follow'] == true)
            .map((usuario) => usuario['login'].toString())
            .toSet();
      }
      return {};
    } catch (e) {
      return {};
    } finally {
      client.close();
    }
  }

  Future<bool> register(UserModel user) async {
    final http.Client client = http.Client();
    final _url = Uri.parse('$url/users');

    try {
      final res = await client.post(
        _url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(user.toJson()),
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        return true;
      } else {
        throw Exception('Falha ao cadastrar (${res.statusCode}): ${res.body}');
      }
    } finally {
      client.close();
    }
  }
}
