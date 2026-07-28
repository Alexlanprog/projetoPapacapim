import 'package:flutter/material.dart';
import 'perfil_page.dart';
import 'busca_page.dart';
import 'feed_page.dart';

class tela_fixa extends StatefulWidget {
  const tela_fixa({super.key});

  @override
  State<tela_fixa> createState() => _tela_fixaState();
}

class _tela_fixaState extends State<tela_fixa> {
  // Índice para controlar qual aba inferior está ativa
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    FeedPage(),      
    BuscaPage(),    
    PerfilPage(),   
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),

      
      
      bottomNavigationBar: NavigationBar(
        indicatorColor: Colors.transparent,
        backgroundColor: const Color(0xFF1E293B),

        selectedIndex: _currentIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _currentIndex = index; 
          });
        },
        destinations:  [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home, color: Color(0xFF8B5CF6)),
            label: 'Feed',
          ),
          NavigationDestination(
            icon: Icon(Icons.search),
            selectedIcon: Icon(Icons.search, color: Color(0xFF8B5CF6)),
            label: 'Buscar',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person, color: Color(0xFF8B5CF6)),
            label: 'Perfil', 
          ),
        ],
      ),
    );
  }
}