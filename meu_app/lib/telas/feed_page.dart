import 'package:flutter/material.dart';
import '../apiService/postApiService.dart';
import '../apiService/userApiService.dart';
import '../apiService/userSession.dart';
import '../models/postMo.dart';
import '../repository/postRepository.dart';
import '../widgets/post.dart';
import 'postagem_page.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final PostRepository _postRepository = PostRepository(PostApiService());
  final UserApiService _userApiService = UserApiService();

  late Future<List<PostModel>> _futurePosts;
  Set<String> _perfisSeguidos = {};

  @override
  void initState() {
    super.initState();
    _carregarFeed();
  }

  void _carregarFeed() async {
    final token = await UserSession.getToken() ?? '';

    // Busca quem o usuário logado segue
    final seguidos = await _userApiService.getUsuariosSeguidos(token: token);

    setState(() {
      _perfisSeguidos = seguidos;
      _futurePosts = _postRepository.getPost(token: token);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFF0F172A),
        appBar: AppBar(
          title: const Text(
            'Rede Social',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: const Color(0xFF0F172A),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: _carregarFeed,
            ),
          ],
          bottom: const TabBar(
            indicatorColor: Color(0xFF8B5CF6),
            labelColor: Color(0xFF8B5CF6),
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: 'Geral'),
              Tab(text: 'Seguindo'), // 👈 Postagens dos perfis que você segue
            ],
          ),
        ),

        body: FutureBuilder<List<PostModel>>(
          future: _futurePosts,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFF8B5CF6)),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Erro ao carregar posts: ${snapshot.error}',
                  style: const TextStyle(color: Colors.redAccent),
                ),
              );
            }

            final todosPosts = snapshot.data ?? [];

            // ✅ Filtra apenas posts de pessoas que estão na lista de seguidos:
            final postsDosSeguidos = todosPosts
                .where((post) => _perfisSeguidos.contains(post.userLogin))
                .toList();

            return TabBarView(
              children: [
                // 1. ABA GERAL: Todas as postagens que o back-end envia
                RefreshIndicator(
                  onRefresh: () async => _carregarFeed(),
                  child: todosPosts.isEmpty
                      ? const Center(
                          child: Text(
                            'Nenhuma publicação.',
                            style: TextStyle(color: Colors.white70),
                          ),
                        )
                      : ListView.builder(
                          itemCount: todosPosts.length,
                          itemBuilder: (context, index) {
                            return PostCard(post: todosPosts[index]);
                          },
                        ),
                ),

                // 2. ABA SEGUINDO: Apenas as postagens de perfis que você segue
                RefreshIndicator(
                  onRefresh: () async => _carregarFeed(),
                  child: postsDosSeguidos.isEmpty
                      ? const Center(
                          child: Text(
                            'Nenhuma postagem dos perfis que você segue.',
                            style: TextStyle(color: Colors.white70),
                          ),
                        )
                      : ListView.builder(
                          itemCount: postsDosSeguidos.length,
                          itemBuilder: (context, index) {
                            return PostCard(post: postsDosSeguidos[index]);
                          },
                        ),
                ),
              ],
            );
          },
        ),

        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFF8B5CF6),
          onPressed: () async {
            final criou = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PublicacaoPage()),
            );
            if (criou == true) _carregarFeed();
          },
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}
