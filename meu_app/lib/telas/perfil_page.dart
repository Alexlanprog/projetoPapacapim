import 'package:flutter/material.dart';
import '../widgets/avatar.dart';
import 'alteracaodados_page.dart';
import '/widgets/post.dart';

class PerfilPage extends StatelessWidget {
  const PerfilPage({super.key});

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color(0xFF0F172A),

    appBar: AppBar(
      title: const Text(
        '@nome_do_usuario',
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: const Color(0xFF0F172A),
    ),

    body: SingleChildScrollView(

      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Cabeçalho com Stack
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
                    color: Colors.blueAccent,
                  ),
                ),
              ),
              Positioned(
                top: 50,
                left: 20,
                child: AvatarPerfil(
                  radius: 44,
                  isMeuPerfil: true,
                ),
              ),
              Positioned(
                top: 10,
                right: 20,
                child: _buildBotaoPerfil(
                  context: context,
                  isMeuPerfil: true, 
                  isSeguindo: false,
                  onPressed: () {},
                ),
              ),
            ],   
          ),
        ), 

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const Text(
                "Nome do Usuário",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const Text(
                '@nome_do_usuario',
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                "Biografia do usuário...",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 16),

              // Seguidores e Seguindo
              Row(
                children: const [

                  Text(
                    "0",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  
                  SizedBox(width: 4),

                  Text(
                    'Seguindo',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),

                  SizedBox(width: 20),

                    Text(
                      "0",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                  ),

                  SizedBox(width: 4),
                  
                    Text(
                      'Seguidores',
                      style: TextStyle(
                        color: Colors.grey,
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
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Text(
            'Publicações',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      PostCard(isMeuPerfil: true),
      ], 
      ),
    ), 
  );
}
  Widget _buildBotaoPerfil({
  required BuildContext context,
  required bool isMeuPerfil,
  required bool isSeguindo,
  required VoidCallback onPressed,
}) 
  {
    if (isMeuPerfil) {
      return OutlinedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AlteracaoDadosPage()),
          );
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

    if (isSeguindo) {
      return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2E384D), // Cinza escuro/azul azulado
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
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF8B5CF6), // Roxo preenchido
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: const Text(
        'Seguir',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}
