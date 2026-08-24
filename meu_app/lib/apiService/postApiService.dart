import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:meu_app/models/postMo.dart';

//  https://api.papacapim.just.pro.br

class PostApiService {
  final String url = 'https://api.papacapim.just.pro.br';

  Future<List<PostModel>> getPost({required String token}) async {
    final http.Client client = http.Client();
    final _url = Uri.parse('https://api.papacapim.just.pro.br/posts');

    try {
      final res = await client.get(
        _url,
        headers: {'x-session-token': token, 'Content-Type': 'application/json'},
      );

      if (res.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(res.body);
        return jsonList
            .map((json) => PostModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Falha ${res.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao carregar posts $e');
    } finally {
      client.close();
    }
  }

  Future<PostModel> writePost(PostModel post, {required String token}) async {
    final http.Client client = http.Client();
    final _url = Uri.parse('https://api.papacapim.just.pro.br/posts');

    try {
      final res = await client.post(
        _url,
        headers: {'x-session-token': token, 'Content-Type': 'application/json'},
        body: jsonEncode(post.toJson()),
      );

      if (res.statusCode == 201 || res.statusCode == 200) {
        return PostModel.fromJson(jsonDecode(res.body));
      } else {
        throw Exception('Falha ao criar post: ${res.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao criar post $e');
    } finally {
      client.close();
    }
  }
}
