import 'package:flutter/material.dart';
import 'package:meu_app/apiService/postApiService.dart';
import 'package:meu_app/apiService/userApiService.dart';
import 'package:meu_app/apiService/userSession.dart';
import 'package:meu_app/models/postMo.dart';
import '../widgets/avatar.dart';
import 'alteracaodados_page.dart';
import '/widgets/post.dart';

class PerfilPage extends StatefulWidget {
  final String? userLogin; // Se nulo, carrega o próprio usuário logado

  const PerfilPage({super.key, this.userLogin});

  @override
  State<PerfilPage> createState() => PerfilPageState();
}

class PerfilPageState extends State<PerfilPage> {
  final UserApiService _userApiService = UserApiService();
  final PostApiService _postApiService = PostApiService();

  bool _isLoading = true;
  String _login = '';
  String _nome = '';
  int _seguidores = 0;
  int _seguindo = 0;
  bool _isMeuPerfil = true;
  bool _isSeguindo = false;
  List<PostModel> _posts = [];

  @override
  void initState() {
    super.initState();
    _carregarPerfil();
  }

  void carregarPerfil() {
    _carregarPerfil();
  }

  Future<void> _carregarPerfil() async {
    final token = await UserSession.getToken();
    final meuLogin = await UserSession.getUsername();

    if (token == null) return;

    final targetLogin = widget.userLogin ?? meuLogin ?? '';
    final isProprioPerfil =
        (widget.userLogin == null || widget.userLogin == meuLogin);

    try {
      // 1. Busca dados do perfil
      final dados = await _userApiService.pegarPerfil(
        targetLogin,
        token: token,
      );

      // 2. Busca posts do usuário
      var posts = await _postApiService.getPostsDoUsuario(
        targetLogin,
        token: token,
      );

      // Se a rota específica de posts do usuário vier vazia,
      // busca no feed geral e filtra pelo login do usuário como garantia!
      if (posts.isEmpty) {
        try {
          final todos = await _postApiService.getPost(token: token);
          final meus = todos
              .where((p) =>
                  p.userLogin.toLowerCase() == targetLogin.toLowerCase())
              .toList();
          if (meus.isNotEmpty) {
            posts = meus;
          }
        } catch (_) {}
      }

      final youFollow = dados['you_follow'] == true;
      if (meuLogin != null && meuLogin.isNotEmpty && !isProprioPerfil) {
        if (youFollow) {
          await UserSession.adicionarSeguido(meuLogin, targetLogin);
        } else {
          await UserSession.removerSeguido(meuLogin, targetLogin);
        }
      }

      if (mounted) {
        setState(() {
          _isMeuPerfil = isProprioPerfil;
          _nome = dados['name'] ?? targetLogin;
          _login = dados['login'] ?? targetLogin;
          _seguidores = dados['followers_number'] ?? 0;
          _seguindo = dados['following_number'] ?? 0;
          _isSeguindo = youFollow;
          _posts = posts;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao carregar perfil: $e')));
      }
    }
  }

  Future<void> _logout() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text(
          'Sair da conta',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Deseja realmente sair?',
          style: TextStyle(color: Color(0xFF94A3B8)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: Color(0xFF94A3B8)),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Sair', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmar != true) return;

    await UserSession.clearSession();
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }

  Future<void> _Seguir() async {
    final token = await UserSession.getToken();
    final meuLogin = await UserSession.getUsername();
    if (token == null) return;

    final novoEstado = !_isSeguindo;

    // Atualiza a tela imediatamente (feedback instantâneo)
    setState(() {
      _isSeguindo = novoEstado;
      if (novoEstado) {
        _seguidores++;
      } else {
        if (_seguidores > 0) _seguidores--;
      }
    });

    try {
      if (novoEstado) {
        await _userApiService.seguirUsuario(_login, token: token);
        if (meuLogin != null && meuLogin.isNotEmpty) {
          await UserSession.adicionarSeguido(meuLogin, _login);
        }
      } else {
        await _userApiService.deixarDeSeguirUsuario(_login, token: token);
        if (meuLogin != null && meuLogin.isNotEmpty) {
          await UserSession.removerSeguido(meuLogin, _login);
        }
      }
    } catch (e) {
      // Se a API falhar, desfaz a alteração na tela
      if (mounted) {
        setState(() {
          _isSeguindo = !novoEstado;
          if (novoEstado) {
            if (_seguidores > 0) _seguidores--;
          } else {
            _seguidores++;
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao atualizar seguidor: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          '@$_login',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF0F172A),
        actions: [
          if (_isMeuPerfil)
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.redAccent),
              tooltip: 'Sair da conta',
              onPressed: _logout,
            ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF8B5CF6)),
            )
          : RefreshIndicator(
              onRefresh: _carregarPerfil,
              color: const Color(0xFF8B5CF6),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Banner e Avatar
                    SizedBox(
                      height: 150,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 100,
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                color: Color(0xFF1E3A8A),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 50,
                            left: 20,
                            child: AvatarPerfil(
                              radius: 44,
                              isMeuPerfil: _isMeuPerfil,
                            ),
                          ),
                          Positioned(
                            top: 10,
                            right: 20,
                            child: _buildBotaoPerfil(),
                          ),
                        ],
                      ),
                    ),

                    // 2. Dados do usuário
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _nome.isNotEmpty ? _nome : _login,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '@$_login',
                            style: const TextStyle(
                              color: Color(0xFF94A3B8),
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Seguidores e Seguindo
                          Row(
                            children: [
                              Text(
                                '$_seguindo',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Text(
                                'Seguindo',
                                style: TextStyle(
                                  color: Color(0xFF94A3B8),
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(width: 20),
                              Text(
                                '$_seguidores',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Text(
                                'Seguidores',
                                style: TextStyle(
                                  color: Color(0xFF94A3B8),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                    const Divider(color: Color(0xFF1E293B), thickness: 4),

                    // 3. Sessão de Publicações
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      child: Text(
                        'Publicações',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),

                    if (_posts.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(32.0),
                        child: Center(
                          child: Text(
                            'Nenhuma publicação ainda.',
                            style: TextStyle(
                              color: Color(0xFF94A3B8),
                              fontSize: 15,
                            ),
                          ),
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _posts.length,
                        itemBuilder: (context, index) {
                          return PostCard(
                            post: _posts[index],
                            isMeuPerfil: _isMeuPerfil,
                            onDelete: _carregarPerfil,
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildBotaoPerfil() {
    if (_isMeuPerfil) {
      return OutlinedButton(
        onPressed: () async {
          // Quando voltar da tela de alteração, recarrega os dados atualizados!
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AlteracaoDadosPage()),
          );
          _carregarPerfil();
        },
        style: OutlinedButton.styleFrom(
          backgroundColor: const Color(0xFF8B5CF6),
          side: const BorderSide(color: Colors.white, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: const Text(
          'Editar Perfil',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      );
    }
    if (_isSeguindo) {
      return ElevatedButton(
        onPressed: _Seguir,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF334155),
          side: const BorderSide(color: Color(0xFF64748B)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: const Text(
          'Seguindo',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      );
    }
    // 3. Se não estiver seguindo: botão "Seguir" (roxo)
    return ElevatedButton(
      onPressed: _Seguir,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF8B5CF6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: const Text(
        'Seguir',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}
