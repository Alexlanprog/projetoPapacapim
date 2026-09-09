import 'package:flutter/material.dart';
import 'feed_page.dart';
import '../widgets/avatar.dart';
import '../models/postMo.dart';
import '../repository/postRepository.dart';
import '../apiService/userSession.dart';
import '../apiService/postApiService.dart';

class PublicacaoPage extends StatefulWidget {
  const PublicacaoPage({super.key});

  @override
  State<PublicacaoPage> createState() => _PublicacaoPageState();
}

class _PublicacaoPageState extends State<PublicacaoPage> {
  final TextEditingController _conteudoController = TextEditingController();

  String _usuario = ''; 
  @override
  void initState() {
    super.initState();
    _carregarUsuario(); 
  }

  void _carregarUsuario() async {
    final nome = await UserSession.getUsername();
    setState(() {
      _usuario = nome ?? '';
    });
  }

  @override
  void dispose() {
    _conteudoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final initial = _usuario.isNotEmpty ? _usuario[0].toUpperCase() : 'U';

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),

        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFF1E293B),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
              onPressed: () {
                Navigator.pop(
                  context,
                  MaterialPageRoute(builder: (context) => const FeedPage()),
                );
              },
              padding: EdgeInsets.zero,
            ),
          ),
        ),
        title: const Text(
          'Nova Publicação',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 10.0,
            ),
            child: ElevatedButton(
              onPressed: () async {
                final conteudo = _conteudoController.text.trim();

                if (conteudo.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('A publicação está vazia')),
                  );
                  return;
                }

                try {
                  final token = await UserSession.getToken();
                  final usuario = await UserSession.getUsername();

                  if (token == null || token.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Sessão expirada. Faça login novamente.'),
                      ),
                    );
                    return;
                  }

                  final repository = PostRepository(PostApiService());
                  await repository.writePost(
                    PostModel(userLogin: usuario ?? '', content: conteudo),
                    token: token,
                  );

                  if (!mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Publicado com sucesso!')),
                  );

                  Navigator.pop(context, true);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erro ao publicar: $e')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E293B),
                foregroundColor: const Color(0xFF94A3B8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Publicar',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: const Color(0xFF3B82F6),
              child: Text(
                initial,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: TextField(
                controller: _conteudoController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                style: const TextStyle(color: Colors.white, fontSize: 18),
                cursorColor: const Color(0xFF8B5CF6),
                decoration: const InputDecoration(
                  hintText: 'O que está acontecendo?',
                  hintStyle: TextStyle(color: Color(0xFF64748B), fontSize: 16),
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
