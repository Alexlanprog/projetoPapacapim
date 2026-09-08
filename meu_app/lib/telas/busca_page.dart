import 'package:flutter/material.dart';
import 'package:meu_app/apiService/postApiService.dart';
import 'package:meu_app/apiService/userApiService.dart';
import 'package:meu_app/apiService/userSession.dart';
import 'package:meu_app/models/UserMo.dart';
import 'package:meu_app/models/postMo.dart';
import 'package:meu_app/telas/perfil_page.dart';
import '/widgets/post.dart';

class BuscaPage extends StatefulWidget {
  const BuscaPage({super.key});

  @override
  State<BuscaPage> createState() => _BuscaPageState();
}

class _BuscaPageState extends State<BuscaPage> {
  final TextEditingController _searchController = TextEditingController();
  final UserApiService _userApiService = UserApiService();
  final PostApiService _postApiService = PostApiService();

  bool _isLoading = false;
  List<UserModel> _todosUsuarios = [];
  List<UserModel> _usuariosFiltrados = [];

  List<PostModel> _todosPosts = [];
  List<PostModel> _postsFiltrados = [];

  @override
  void initState() {
    super.initState();
    _carregarDadosIniciais();
  }

  Future<void> _carregarDadosIniciais() async {
    setState(() => _isLoading = true);
    final token = await UserSession.getToken();
    if (token == null) return;

    try {
      final usuarios = await _userApiService.pegarUsuarios(token: token);
      final posts = await _postApiService.getPost(token: token);

      if (mounted) {
        setState(() {
          _todosUsuarios = usuarios;
          _usuariosFiltrados = usuarios;
          _todosPosts = posts;
          _postsFiltrados = posts;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _filtrar(String query) {
    final q = query.trim().toLowerCase();
    setState(() {
      if (q.isEmpty) {
        _usuariosFiltrados = _todosUsuarios;
        _postsFiltrados = _todosPosts;
      } else {
        _usuariosFiltrados = _todosUsuarios.where((u) {
          return u.login.toLowerCase().contains(q) ||
              u.name.toLowerCase().contains(q);
        }).toList();

        _postsFiltrados = _todosPosts.where((p) {
          return p.content.toLowerCase().contains(q) ||
              p.userLogin.toLowerCase().contains(q);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFF0F172A),
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: const Color(0xFF1E293B),
          title: TextField(
            controller: _searchController,
            onChanged: _filtrar,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Buscar usuários ou publicações...',
              hintStyle: const TextStyle(
                color: Color(0xFF94A3B8),
                fontSize: 14,
              ),
              prefixIcon: const Icon(Icons.search, color: Color(0xFF94A3B8)),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: Color(0xFF94A3B8)),
                      onPressed: () {
                        _searchController.clear();
                        _filtrar('');
                      },
                    )
                  : null,
              filled: true,
              fillColor: const Color(0xFF0F172A),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          bottom: const TabBar(
            indicatorColor: Color(0xFF8B5CF6),
            labelColor: Color(0xFF8B5CF6),
            unselectedLabelColor: Color(0xFF94A3B8),
            tabs: [
              Tab(text: 'Usuários'),
              Tab(text: 'Publicações'),
            ],
          ),
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Color(0xFF8B5CF6)),
              )
            : TabBarView(
                children: [
                  // Aba 1: Lista de Usuários
                  _usuariosFiltrados.isEmpty
                      ? const Center(
                          child: Text(
                            'Nenhum usuário encontrado.',
                            style: TextStyle(
                              color: Color(0xFF94A3B8),
                              fontSize: 15,
                            ),
                          ),
                        )
                      : ListView.separated(
                          itemCount: _usuariosFiltrados.length,
                          separatorBuilder: (_, __) => const Divider(
                            color: Color(0xFF1E293B),
                            height: 1,
                          ),
                          itemBuilder: (context, index) {
                            final user = _usuariosFiltrados[index];
                            final initial = user.login.isNotEmpty
                                ? user.login[0].toUpperCase()
                                : 'U';

                            return ListTile(
                              leading: CircleAvatar(
                                radius: 22,
                                backgroundColor: const Color(0xFF8B5CF6),
                                child: Text(
                                  initial,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              title: Text(
                                user.name.isNotEmpty ? user.name : user.login,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                '@${user.login}',
                                style: const TextStyle(
                                  color: Color(0xFF94A3B8),
                                ),
                              ),
                              trailing: const Icon(
                                Icons.chevron_right,
                                color: Colors.white,
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        PerfilPage(userLogin: user.login),
                                  ),
                                );
                              },
                            );
                          },
                        ),

                  // Aba 2: Lista de Publicações
                  _postsFiltrados.isEmpty
                      ? const Center(
                          child: Text(
                            'Nenhuma publicação encontrada.',
                            style: TextStyle(
                              color: Color(0xFF94A3B8),
                              fontSize: 15,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: _postsFiltrados.length,
                          itemBuilder: (context, index) {
                            final post = _postsFiltrados[index];
                            return PostCard(
                              post: post,
                              isMeuPerfil: false,
                              onUserTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        PerfilPage(userLogin: post.userLogin),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                ],
              ),
      ),
    );
  }
}
