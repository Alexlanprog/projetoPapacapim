import 'package:flutter/material.dart';


class AlteracaoDadosPage extends StatelessWidget {
  const AlteracaoDadosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Alterar Dados',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          
        ),
        backgroundColor: const Color(0xFF0F172A),
        iconTheme: const IconThemeData(
        color: Colors.white, // 👈 Muda a cor da seta para branco (ou a cor que desejar)
  ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              SizedBox(
                  width: 90,
                  height: 90,
              child: Stack(  
                children: [
            
                Center(
                    child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF4C8DF5),
                ),
                    child: const Center(
                      child: Text(
                        'A', 
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 53, 
                          fontWeight: FontWeight.bold,
                     ),
                    ),
                  ),
                ),
                ),
            ],
          ),
        ),

        const SizedBox(height: 10), 

        Center (
          child: Text(
          'Alterar Foto de Perfil',
          style: TextStyle(
            color: Color(0xFF8B5CF6),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        ),

           const SizedBox(height: 8), 

              const Text(
                      'Nome Exibido',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
              ),
                const SizedBox(height: 5),

             TextFormField(
                style: const TextStyle(color: Colors.white),
                decoration:  InputDecoration(
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

              const SizedBox(height: 20),

              const Text(
                      'Descrição',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
              ),
                const SizedBox(height: 5),

              TextFormField(
                style: const TextStyle(color: Colors.white),
                decoration:  InputDecoration(
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

               const SizedBox(height: 20),

              const Text(
                      'Senha Atual',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
              ),
                const SizedBox(height: 5),

              TextFormField(
                style: const TextStyle(color: Colors.white),
                decoration:  InputDecoration(
                  border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const  BorderSide(color: Color(0xFF8B5CF6)),
                      ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xFF8B5CF6), width: 1.5),
                      )  
                ),
                obscureText: true,
              ),

               const SizedBox(height: 20),

              const Text(
                      'Nova Senha',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
              ),
                const SizedBox(height: 5),

              TextFormField(
                style: const TextStyle(color: Colors.white),
                decoration:  InputDecoration(
                  border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const  BorderSide(color: Color(0xFF8B5CF6)),
                      ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xFF8B5CF6), width: 1.5),
                      )  
                ),
                obscureText: true,
              ),

              const SizedBox(height: 8),


           Center (
              child: ElevatedButton(
              onPressed: () {
                // Ação ao pressionar o botão
              },
              child: const Text('Salvar Alterações'),
              
              style: ElevatedButton.styleFrom(

                foregroundColor: Colors.white,
                backgroundColor: const Color(0xFF8B5CF6), // Cor de fundo vermelha
              ),
            ),
            ),

              const SizedBox(height: 8),

            Center(
             child :ElevatedButton(
              onPressed: () {
                // Ação ao pressionar o botão
              },
              child: const Text('Excluir Perfil'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red, // Cor de fundo vermelha
              ),
            ),
            )
            ],
          ),
        ),
      )
    );
  }
}


