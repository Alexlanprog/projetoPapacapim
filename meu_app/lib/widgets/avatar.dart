import 'package:flutter/material.dart';

class AvatarPerfil extends StatelessWidget {
    final double radius;

  const AvatarPerfil({super.key
  , this.radius = 20});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        color: Colors.white, // Cor da borda
        shape: BoxShape.circle,
      // Se quiser uma borda extra: border: Border.all(color: Colors.black, width: 1),
        ),
        child: Center( 
          child: CircleAvatar(
            radius: radius - 2, 
            backgroundColor: const Color(0xFF8B5CF6), // Cor de fundo do avatar
            child: Text(
              'A',
              style: TextStyle(
                color: Colors.white,
                fontSize: radius * 0.9,
                fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
