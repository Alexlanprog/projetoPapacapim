import 'package:flutter/material.dart';
import 'package:meu_app/models/postMo.dart';

class PostCard extends StatelessWidget {
  final PostModel? post;
  final bool isMeuPerfil;
  final VoidCallback? onUserTap;

  const PostCard({
    super.key,
    this.isMeuPerfil = false,
    this.onUserTap,
    this.post,
  });

  @override
  Widget build(BuildContext context) {
    final authorLogin = post?.userLogin.isNotEmpty == true
        ? post!.userLogin
        : (isMeuPerfil ? 'Você' : 'Usuário');

    final initial = authorLogin.isNotEmpty ? authorLogin[0].toUpperCase() : 'P';

    final content = post?.content.isNotEmpty == true
        ? post!.content
        : (isMeuPerfil
              ? 'Estou prototipando a interface de uma nova rede social no Flutter hoje.'
              : 'Acabei de tirar essa foto incrível no parque da cidade!');

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF334155), width: 1),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: onUserTap ?? () {},
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: isMeuPerfil
                            ? const Color(0xFF3B82F6)
                            : const Color(0xFFEC4899),
                        child: Text(
                          initial,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              authorLogin,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '@$authorLogin',
                              style: const TextStyle(
                                color: Color(0xFF94A3B8),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              if (isMeuPerfil)
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.redAccent,
                    size: 22,
                  ),
                ),
            ],
          ),

          const SizedBox(height: 14),

          Text(
            content,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 16),
          const Divider(color: Color(0xFF334155), height: 1),
          const SizedBox(height: 12),

          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.favorite_border,
                  color: Color(0xFF94A3B8),
                  size: 20,
                ),
              ),

              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.chat_bubble_outline,
                  color: Color(0xFF94A3B8),
                  size: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
