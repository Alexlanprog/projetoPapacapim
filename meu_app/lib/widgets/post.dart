import 'package:flutter/material.dart';
import 'package:meu_app/apiService/postApiService.dart';
import 'package:meu_app/apiService/userSession.dart';
import 'package:meu_app/models/postMo.dart';

//ver a questao de imagem do perfil

class PostCard extends StatefulWidget {
  final PostModel? post;
  final bool isMeuPerfil;
  final VoidCallback? onUserTap;
  final VoidCallback? onDelete;

  const PostCard({
    super.key,
    this.isMeuPerfil = false,
    this.onUserTap,
    this.onDelete,
    this.post,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  final PostApiService _apiService = PostApiService();
  bool _curtido = false;

  @override
  void initState() {
    super.initState();
    _curtido = widget.post?.youLiked ?? false;
  }

  @override
  void didUpdateWidget(covariant PostCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.post?.youLiked != widget.post?.youLiked) {
      _curtido = widget.post?.youLiked ?? false;
    }
  }

  Future<void> _toggleCurtida() async {
    final postId = widget.post?.id;
    if (postId == null) return;

    final token = await UserSession.getToken();
    if (token == null) return;

    setState(() {
      _curtido = !_curtido;
    });

    try {
      if (_curtido) {
        await _apiService.curtirPost(postId, token: token);
      } else {
        await _apiService.descurtiPost(postId, token: token);
      }
    } catch (e) {
      // Se der erro, desfaz a alteração visual
      if (mounted) {
        setState(() {
          _curtido = !_curtido;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao atualizar curtida: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  Future<void> _deletarPost() async {
    final postId = widget.post?.id;
    if (postId == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text(
          'Excluir postagem',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Deseja realmente apagar esta postagem?',
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
            child: const Text('Excluir', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final token = await UserSession.getToken();
    if (token == null) return;

    try {
      await _apiService.deletePost(postId, token: token);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Postagem excluída com sucesso!'),
            backgroundColor: Color(0xFF10B981),
          ),
        );
        widget.onDelete?.call();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao excluir: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  void _abrirComentarios() {
    final postId = widget.post?.id;
    if (postId == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF0F172A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) =>
          _ModalComentarios(postId: postId, apiService: _apiService),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authorLogin = widget.post?.userLogin.isNotEmpty == true
        ? widget.post!.userLogin
        : (widget.isMeuPerfil ? 'Você' : 'Usuário');

    final initial = authorLogin.isNotEmpty ? authorLogin[0].toUpperCase() : 'U';

    final content = widget.post?.content.isNotEmpty == true
        ? widget.post!.content
        : (widget.isMeuPerfil
              ? 'Estou prototipando a interface de uma nova rede social no Flutter hoje.'
              : 'Acabei de tirar essa foto incrível no parque da cidade!');

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF334155), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: widget.onUserTap ?? () {},
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: widget.isMeuPerfil
                            ? const Color(0xFF3B82F6)
                            : const Color(0xFFEC4899),
                        child: Text(
                          initial,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              authorLogin,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '@$authorLogin',
                              style: const TextStyle(
                                color: Color(0xFF94A3B8),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              if (widget.isMeuPerfil)
                IconButton(
                  onPressed: _deletarPost,
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.redAccent,
                    size: 22,
                  ),
                ),
            ],
          ),

          const SizedBox(height: 14),

          Text(
            content,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 16),
          const Divider(color: Color(0xFF334155), height: 1),
          const SizedBox(height: 8),

          Row(
            children: [
              IconButton(
                onPressed: _toggleCurtida,
                icon: Icon(
                  _curtido ? Icons.favorite : Icons.favorite_border,
                  color: _curtido ? Colors.redAccent : const Color(0xFF94A3B8),
                  size: 22,
                ),
              ),

              IconButton(
                onPressed: _abrirComentarios,
                icon: const Icon(
                  Icons.chat_bubble_outline,
                  color: Color(0xFF94A3B8),
                  size: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ModalComentarios extends StatefulWidget {
  final int postId;
  final PostApiService apiService;

  const _ModalComentarios({required this.postId, required this.apiService});

  @override
  State<_ModalComentarios> createState() => _ModalComentariosState();
}

class _ModalComentariosState extends State<_ModalComentarios> {
  final TextEditingController _comentarioController = TextEditingController();
  List<PostModel> _respostas = [];
  bool _carregando = true;
  bool _enviando = false;

  @override
  void initState() {
    super.initState();
    _carregarRespostas();
  }

  Future<void> _carregarRespostas() async {
    final token = await UserSession.getToken();
    if (token == null) return;

    try {
      final lista = await widget.apiService.listarRespostas(
        widget.postId,
        token: token,
      );
      if (mounted) {
        setState(() {
          _respostas = lista;
          _carregando = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _carregando = false);
    }
  }

  Future<void> _enviarComentario() async {
    final texto = _comentarioController.text.trim();
    if (texto.isEmpty) return;

    final token = await UserSession.getToken();
    if (token == null) return;

    setState(() => _enviando = true);

    try {
      await widget.apiService.comentarPost(widget.postId, texto, token: token);
      _comentarioController.clear();
      await _carregarRespostas();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao comentar: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _enviando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.65,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Respostas',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(color: Color(0xFF334155), height: 24),

            Expanded(
              child: _carregando
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF8B5CF6),
                      ),
                    )
                  : _respostas.isEmpty
                  ? const Center(
                      child: Text(
                        'Nenhum comentário ainda. Seja o primeiro!',
                        style: TextStyle(color: Color(0xFF94A3B8)),
                      ),
                    )
                  : ListView.separated(
                      itemCount: _respostas.length,
                      separatorBuilder: (_, __) =>
                          const Divider(color: Color(0xFF1E293B)),
                      itemBuilder: (ctx, i) {
                        final resp = _respostas[i];
                        final initial = resp.userLogin.isNotEmpty
                            ? resp.userLogin[0].toUpperCase()
                            : 'U';
                        return ListTile(
                          leading: CircleAvatar(
                            radius: 18,
                            backgroundColor: const Color(0xFF8B5CF6),
                            child: Text(
                              initial,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(
                            '@${resp.userLogin}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          subtitle: Text(
                            resp.content,
                            style: const TextStyle(
                              color: Color(0xFFCBD5E1),
                              fontSize: 13,
                            ),
                          ),
                        );
                      },
                    ),
            ),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _comentarioController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Escreva uma resposta...',
                      hintStyle: const TextStyle(color: Color(0xFF64748B)),
                      filled: true,
                      fillColor: const Color(0xFF1E293B),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _enviando ? null : _enviarComentario,
                  icon: _enviando
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Color(0xFF8B5CF6),
                          ),
                        )
                      : const Icon(
                          Icons.send_rounded,
                          color: Color(0xFF8B5CF6),
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
