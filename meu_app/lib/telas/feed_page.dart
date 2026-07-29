import 'package:flutter/material.dart';
import '/widgets/post.dart';
import 'postagem_page.dart';

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

            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 16),
                  
                  PostCard(isMeuPerfil: false),
                  PostCard(isMeuPerfil: false),
                  PostCard(isMeuPerfil: false),
                ],
              ),
            ),

            SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 16),
                  
                  PostCard(isMeuPerfil: false),
              ],
            ),
            )
          ], 
        ),
        
          floatingActionButton: FloatingActionButton(
            backgroundColor: const Color(0xFF8B5CF6),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PublicacaoPage()),
                );
             },
            child: const Icon(Icons.add, color: Colors.white, size: 28),
          ),
      ),
    );
  }
}