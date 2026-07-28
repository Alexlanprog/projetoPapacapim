import 'package:flutter/material.dart';
import 'tela_fixa.dart';
import '/widgets/post.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 2,
      child:Scaffold(
      appBar: AppBar(
          title: const Text('Rede Social',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          ),
          backgroundColor: const Color(0xFF0F172A),

          bottom: TabBar(
            tabs: const  [
            Tab(text: 'Seguindo'),
            Tab(text: 'Perfil'),
          ]),
        ),

      backgroundColor: const Color(0xFF0F172A),
      body: TabBarView(
          children: [
            // ABA 1: SEGUINDO (Adicionado o Post aqui)
            SingleChildScrollView(
              child: Column(
                children: const [
                  SizedBox(height: 16),
                  
                  // 👇 Post de outra pessoa (Sem botão de excluir)
                  PostCard(isMeuPerfil: false),
                  PostCard(isMeuPerfil: false),
                ],
              ),
            ),
          ], 
        ),
      ),
    );
  }
}