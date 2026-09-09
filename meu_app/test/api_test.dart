import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:meu_app/apiService/postApiService.dart';

// token 609e1c3b-b644-42c9-8bd8-d4f1c96ed495
// login AlexUser
// senha papacapim123

Future<String?> obterToken({
  required String login,
  required String password,
}) async {
  final url = Uri.parse('https://api.papacapim.just.pro.br/sessions');

  final res = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'login': login, 'password': password}),
  );

  if (res.statusCode == 200 || res.statusCode == 201) {
    final data = jsonDecode(res.body);
    return data['token'] ?? res.headers['x-session-token'];
  } else {
    print('Erro ao obter token: ${res.statusCode} - ${res.body}');
    return null;
  }
}

void main() {
  test('Testa se a API responde ao buscar posts', () async {
    final apiService = PostApiService();

    final token = await obterToken(login: 'AlexUser', password: 'papacapim123');

    if (token != null) {
      final posts = await apiService.getPost(token: token);
      print('Sucesso! Posts recebidos: ${posts.length}');
      expect(posts, isNotNull);
    } else {
      fail('Não foi possível obter o token de acesso.');
    }
  });
}
