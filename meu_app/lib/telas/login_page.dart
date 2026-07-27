import 'package:flutter/material.dart';
import 'cadastro_page.dart';
import 'tela_fixa.dart';



class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [


            TextFormField(
              style: const TextStyle(color: Colors.white),
              decoration:  InputDecoration(
                labelText: 'Nome de usuário ou Email',
                border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const  BorderSide(color: Color(0xFF8B5CF6)),
                    ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: Color(0xFF8B5CF6), width: 1.5),
                    )  
              ),
            ),

            const SizedBox(height: 16),

            TextFormField(
              style: const TextStyle(color: Colors.white),
              decoration:  InputDecoration(
                labelText: 'Senha',
                border: OutlineInputBorder(
                      borderRadius:  BorderRadius.circular(16),
                      borderSide: const  BorderSide(color: Color(0xFF8B5CF6)),
                    ),
                focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: Color(0xFF8B5CF6), width: 1.5),
                    )
              ),
              obscureText: true,
            ),
            
            const SizedBox(height: 32),

//botao entrar
            ElevatedButton(
             style: ElevatedButton.styleFrom(
                minimumSize: const Size(150, 50)
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const tela_fixa()),
                );
              },
              child: const Text('Entrar'),
            ),

            const SizedBox(height: 24),

          Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Não tem uma conta?',
                      style: TextStyle(color: Colors.white),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const CadastroPage()),
                        );
                      },
                      child: const Text(
                        'Cadastre-se',
                        style: TextStyle(
                          color: Color(0xFF8B5CF6),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
          
          ],
        ),
      ),
    )
    );
  }
}