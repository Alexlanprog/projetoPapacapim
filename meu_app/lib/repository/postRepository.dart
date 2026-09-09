import 'package:meu_app/apiService/postApiService.dart';
import 'package:meu_app/models/postMo.dart';

class PostRepository {
  final PostApiService apiService;

  PostRepository(this.apiService);

  Future<List<PostModel>> getPost({required String token}) async =>
      apiService.getPost(token: token);

  Future<PostModel> writePost(PostModel post, {required String token}) async =>
      apiService.writePost(post, token: token);
}
