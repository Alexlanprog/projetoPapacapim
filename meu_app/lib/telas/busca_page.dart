import 'package:flutter/material.dart';
import '/widgets/post.dart';

class BuscaPage extends StatelessWidget {
  const BuscaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 2,
      child:Scaffold(
      appBar: AppBar(
          title: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Buscar Usuários ou Publicações',
                hintStyle: const TextStyle(color: Colors.white70, fontSize: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Color(0xFF8B5CF6)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide:
                      const BorderSide(color: Color(0xFF8B5CF6), width: 1.5),
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.white70),
              ),
            ),

          ),
          backgroundColor: const Color(0xFF1E293B),

          bottom: TabBar(
            tabs: const  [
            Tab(text: 'Usuarios'),
            Tab(text: 'Publicações'),
          ]),
        ),

      backgroundColor: const Color(0xFF0F172A),
      body: TabBarView(
        
        children: [
          SingleChildScrollView(
              child:  Text('Usuarios'),
            ),

            SingleChildScrollView(
              child: Column(

                children:  [
                  PostCard(isMeuPerfil: false),
                ]
                
              ),
              
            )
        ]
      ),
    ),
    );
  }
}