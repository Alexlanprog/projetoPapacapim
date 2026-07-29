import 'package:flutter/material.dart';

class AvatarPerfil extends StatelessWidget {
    final double radius;
    final bool isMeuPerfil;

  const AvatarPerfil({
    super.key,
    this.radius = 20,
    this.isMeuPerfil = false,

  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        color: Colors.white, // Cor da borda
        shape: BoxShape.circle,
      
        ),
        child: Center( 
          child: CircleAvatar(
            radius: radius - 2, 
            backgroundColor: const Color(0xFF8B5CF6), 
            child: Text(
              isMeuPerfil ? 'A' : 'J',
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
