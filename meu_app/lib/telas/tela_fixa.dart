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
        selectedIndex: _currentIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _currentIndex = index; 
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Feed',
          ),
          NavigationDestination(
            icon: Icon(Icons.search),
            label: 'Buscar',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}