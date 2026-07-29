import 'package:flutter/material.dart';
import 'feed_page.dart';
import '../widgets/avatar.dart';

class PublicacaoPage extends StatelessWidget{
  const PublicacaoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Fundo escuro
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
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: ElevatedButton(
              onPressed: () {
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E293B), 
                foregroundColor: const Color(0xFF94A3B8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                elevation: 0,
              ),
              child: const Text(
                'Publicar',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
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

            const AvatarPerfil(radius: 22, isMeuPerfil: true,),
             
            const SizedBox(width: 12),

            Expanded(
              child: TextField(
                maxLines: null,
                keyboardType: TextInputType.multiline,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
                cursorColor: const Color(0xFF8B5CF6), 
                decoration: const InputDecoration(
                  hintText: 'O que está acontecendo?',
                  hintStyle: TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 16,
                  ),
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