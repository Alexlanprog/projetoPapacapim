import 'package:flutter/material.dart';
import '../widgets/avatar.dart';

class PerfilPage extends StatelessWidget {
  const PerfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),

      appBar: AppBar(
        title: const Text('@nome_do_usuario',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF0F172A),
      ),

      body: Center(
        child: Column(
          children:  [
            Stack(
              clipBehavior: Clip.none, 
              alignment: Alignment.center,

              children: [
                  Container(
                  height: 100, 
                  width: double.infinity, 
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    ),
                  ),
            
              Positioned(
                bottom: -40,
                right: 180,
                left: 0,
                child: AvatarPerfil(
                    radius: 44
                ),
              ),

            Positioned(
                  bottom: -50, // Fica abaixo da linha do banner
                  right: 20,   // Coloca no canto direito
                  child: _buildBotaoPerfil(
                    isMeuPerfil: true, // Alterar conforme a lógica do seu app
                    isSeguindo: false, // Alterar conforme a lógica do seu app
                    onPressed: () {
                      // Ação ao clicar no botão
                      print('Botão pressionado');
                    },
                  ),
                ),
             ],
            )
          ],
        ),
      ),
    );
  }


  Widget _buildBotaoPerfil({
  required bool isMeuPerfil,
  required bool isSeguindo,
  required VoidCallback onPressed,
}) 
  {
  // CASO 1: É o meu próprio perfil
    if (isMeuPerfil) {
      return OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFF8B5CF6), width: 1.5), // Borda roxa
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

  // CASO 2: É o perfil de outro e já estou SEGUINDO
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

  // CASO 3: É o perfil de outro e NÃO estou seguindo
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
