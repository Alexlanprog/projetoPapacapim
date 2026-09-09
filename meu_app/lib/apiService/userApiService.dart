import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:meu_app/models/UserMo.dart';
import 'package:meu_app/apiService/userSession.dart';

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
    final meuLogin = await UserSession.getUsername() ?? '';
    final seguidosLocais = meuLogin.isNotEmpty
        ? await UserSession.getPerfisSeguidos(meuLogin)
        : <String>{};

    final http.Client client = http.Client();
    try {
      final meRes = await client.get(
        Uri.parse('$url/users/me'),
        headers: {'x-session-token': token, 'Content-Type': 'application/json'},
      );

      if (meRes.statusCode == 200) {
        final meData = jsonDecode(meRes.body);
        final followingNumber = meData['following_number'] ?? 0;
        if (followingNumber == 0) {
          if (meuLogin.isNotEmpty) {
            await UserSession.salvarPerfisSeguidos(meuLogin, {});
          }
          return {};
        }
      }

      final seguidosEncontrados = <String>{...seguidosLocais};
      final futures = List.generate(20, (i) async {
        try {
          final res = await client.get(
            Uri.parse('$url/users?page=${i + 1}'),
            headers: {
              'x-session-token': token,
              'Content-Type': 'application/json',
            },
          );
          if (res.statusCode == 200) {
            final List<dynamic> users = jsonDecode(res.body);
            return users
                .where((usuario) => usuario['you_follow'] == true)
                .map((usuario) => usuario['login'].toString())
                .toList();
          }
        } catch (_) {}
        return <String>[];
      });

      final results = await Future.wait(futures);
      for (final list in results) {
        seguidosEncontrados.addAll(list);
      }

      if (meuLogin.isNotEmpty) {
        await UserSession.salvarPerfisSeguidos(meuLogin, seguidosEncontrados);
      }

      return seguidosEncontrados;
    } catch (e) {
      return seguidosLocais;
    } finally {
      client.close();
    }
  }

  Future<bool> registrar(UserModel user) async {
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

  Future<bool> alterar({
    required String token,
    String? login,
    String? nome,
    String? senha,
    String? imageData,
  }) async {
    final http.Client client = http.Client();
    final _url = Uri.parse('$url/users/me');

    try {
      final Map<String, dynamic> userMap = {};
      if (nome != null && nome.isNotEmpty) {
        userMap['name'] = nome;
      }
      if (login != null && login.isNotEmpty) {
        userMap['login'] = login;
      }
      if (senha != null && senha.isNotEmpty) {
        userMap['password'] = senha;
        userMap['password_confirmation'] = senha;
      }
      if (imageData != null && imageData.isNotEmpty) {
        userMap['image_data'] = imageData;
      }

      if (userMap.isEmpty) {
        throw Exception('Nenhum dado para alterar');
      }

      final res = await client.patch(
        _url,
        headers: {'x-session-token': token, 'Content-Type': 'application/json'},
        body: jsonEncode({"user": userMap}),
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        return true;
      } else {
        throw Exception('Falha ao alterar (${res.statusCode}): ${res.body}');
      }
    } finally {
      client.close();
    }
  }

  Future<bool> deletarConta({required String token}) async {
    final http.Client client = http.Client();
    final _url = Uri.parse('$url/users/me');

    try {
      final res = await client.delete(
        _url,
        headers: {'x-session-token': token, 'Content-Type': 'application/json'},
      );
      if (res.statusCode == 204) {
        return true;
      } else {
        throw Exception('Falha ao deletar (${res.statusCode}): ${res.body}');
      }
    } finally {
      client.close();
    }
  }

  Future<Map<String, dynamic>> pegarPerfil(
    String login, {
    required String token,
  }) async {
    final http.Client client = http.Client();
    try {
      final res = await client.get(
        Uri.parse('$url/users/$login'),
        headers: {'x-session-token': token, 'Content-Type': 'application/json'},
      );
      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      }
      throw Exception('Falha ao carregar perfil: ${res.statusCode}');
    } finally {
      client.close();
    }
  }

  Future<List<UserModel>> pegarUsuarios({
    String? query,
    required String token,
  }) async {
    final http.Client client = http.Client();
    final endpoint = (query != null && query.isNotEmpty)
        ? '$url/users?search=$query'
        : '$url/users';

    try {
      final res = await client.get(
        Uri.parse(endpoint),
        headers: {'x-session-token': token, 'Content-Type': 'application/json'},
      );

      if (res.statusCode == 200) {
        final List<dynamic> list = jsonDecode(res.body);
        return list
            .map((j) => UserModel.fromJson(j as Map<String, dynamic>))
            .toList();
      }
      return [];
    } finally {
      client.close();
    }
  }

  Future<bool> seguirUsuario(String login, {required String token}) async {
    final http.Client client = http.Client();
    final meuLogin = await UserSession.getUsername() ?? '';
    try {
      final res = await client.post(
        Uri.parse('$url/users/$login/followers'),
        headers: {'x-session-token': token, 'Content-Type': 'application/json'},
      );
      if (res.statusCode == 200 ||
          res.statusCode == 201 ||
          res.statusCode == 204 ||
          (res.statusCode == 422 && res.body.contains('already been taken'))) {
        if (meuLogin.isNotEmpty) {
          await UserSession.adicionarSeguido(meuLogin, login);
        }
        return true;
      } else {
        throw Exception('Falha ao seguir (${res.statusCode}): ${res.body}');
      }
    } finally {
      client.close();
    }
  }

  Future<bool> deixarDeSeguirUsuario(
    String login, {
    required String token,
  }) async {
    final http.Client client = http.Client();
    final meuLogin = await UserSession.getUsername() ?? '';
    try {
      final res = await client.delete(
        Uri.parse('$url/users/$login/followers/me'),
        headers: {'x-session-token': token, 'Content-Type': 'application/json'},
      );
      if (res.statusCode == 200 || res.statusCode == 204) {
        if (meuLogin.isNotEmpty) {
          await UserSession.removerSeguido(meuLogin, login);
        }
        return true;
      } else {
        throw Exception(
          'Falha ao deixar de seguir (${res.statusCode}): ${res.body}',
        );
      }
    } finally {
      client.close();
    }
  }
}
