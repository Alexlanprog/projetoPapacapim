import 'package:flutter/material.dart';
import 'package:meu_app/widgets/camera.dart';
import 'package:meu_app/apiService/userApiService.dart';
import 'package:meu_app/apiService/userSession.dart';

//ver botao de deletar conta

class AlteracaoDadosPage extends StatefulWidget {
  const AlteracaoDadosPage({super.key});

  @override
  State<AlteracaoDadosPage> createState() => _AlteracaoDadosPageState();
}

class _AlteracaoDadosPageState extends State<AlteracaoDadosPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _senhaAtualController = TextEditingController();
  final TextEditingController _novaSenhaController = TextEditingController();

  void _showOpcoesFoto(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E293B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Alterar Foto de Perfil',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              ListTile(
                leading: const Icon(
                  Icons.camera_alt,
                  color: Color(0xFF8B5CF6),
                  size: 28,
                ),
                title: const Text(
                  'Tirar Foto (Câmera Simulada)',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Camera()),
                  );
                },
              ),

              ListTile(
                leading: const Icon(
                  Icons.image,
                  color: Color(0xFF38BDF8),
                  size: 28,
                ),
                title: const Text(
                  'Escolhar da Galeria',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text(
          'Alterar Dados',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF0F172A),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  height: 80,
                  width: 80,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF1E3A8A),
                  ),
                  child: const Center(
                    child: Text(
                      'V',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Center(
                child: TextButton(
                  onPressed: () => _showOpcoesFoto(context),
                  child: const Text(
                    'Alterar Foto de Perfil',
                    style: TextStyle(
                      color: Color(0xFF8B5CF6),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Login',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              TextFormField(
                controller: _loginController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFF8B5CF6)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: Color(0xFF8B5CF6),
                      width: 1.5,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'Nome',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              TextFormField(
                controller: _nomeController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFF8B5CF6)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: Color(0xFF8B5CF6),
                      width: 1.5,
                    ),
                  ),
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
                controller: _senhaAtualController,
                style: const TextStyle(color: Colors.white),
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFF8B5CF6)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: Color(0xFF8B5CF6),
                      width: 1.5,
                    ),
                  ),
                ),
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
                controller: _novaSenhaController,
                style: const TextStyle(color: Colors.white),
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFF8B5CF6)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: Color(0xFF8B5CF6),
                      width: 1.5,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    final novoNome = _nomeController.text.trim();
                    final login = _loginController.text.trim();
                    final novaSenha = _senhaAtualController.text.trim();
                    final novaSenha_confirmada = _novaSenhaController.text
                        .trim();

                    if (novoNome.isEmpty &&
                        login.isEmpty &&
                        novaSenha.isEmpty &&
                        novaSenha_confirmada.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Preencha ao menos um campo para alterar',
                          ),
                        ),
                      );
                      return;
                    }

                    if (novaSenha != novaSenha_confirmada &&
                        novaSenha.length < 6) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'As senhas não coincidem ou senha menor que 6 caracteres',
                          ),
                        ),
                      );
                      return;
                    }

                    setState(() => _isLoading = true);

                    try {
                      final token = await UserSession.getToken();
                      if (token == null) {
                        throw Exception('Token não encontrado');
                      }

                      final sucesso = await UserApiService().alterar(
                        token: token,
                        login: login.isNotEmpty ? login : null,
                        nome: novoNome.isNotEmpty ? novoNome : null,
                        senha: novaSenha.isNotEmpty ? novaSenha : null,
                      );

                      if (!mounted) return;

                      if (sucesso) {
                        if (login.isNotEmpty) {
                          await UserSession.saveSession(
                            token: token,
                            userName: login,
                          );
                        }

                        if (novaSenha.isNotEmpty) {
                          await UserSession.clearSession();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Senha alterada! Por segurança, faça login novamente.',
                              ),
                              backgroundColor: Colors.green,
                            ),
                          );
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/login',
                            (route) => false,
                          );
                          return;
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Dados atualizados com sucesso!'),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Falha ao atualizar dados!'),
                          ),
                        );
                      }
                    } catch (e) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Erro ao atualizar dados: $e')),
                      );
                    } finally {
                      if (mounted) {
                        setState(() => _isLoading = false);
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xFF8B5CF6),
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Salvar Alterações'),
                ),
              ),

              const SizedBox(height: 12),

              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    // 1. Pede confirmação antes de excluir
                    final confirmar = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        backgroundColor: const Color(0xFF1E293B),
                        title: const Text(
                          'Excluir Perfil',
                          style: TextStyle(color: Colors.white),
                        ),
                        content: const Text(
                          'Deseja realmente apagar sua conta? Essa ação é permanente e não pode ser desfeita.',
                          style: TextStyle(color: Color(0xFF94A3B8)),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, false),
                            child: const Text(
                              'Cancelar',
                              style: TextStyle(color: Color(0xFF94A3B8)),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                            ),
                            onPressed: () => Navigator.pop(ctx, true),
                            child: const Text(
                              'Excluir',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    );

                    // Se cancelou, não faz nada
                    if (confirmar != true) return;

                    setState(() => _isLoading = true);

                    try {
                      final token = await UserSession.getToken();
                      if (token == null) {
                        throw Exception('Token não encontrado');
                      }

                      // 2. Chama a API para deletar a conta
                      final sucesso = await UserApiService().deletarConta(
                        token: token,
                      );

                      if (!mounted) return;

                      if (sucesso) {
                        // 3. Limpa a sessão local
                        await UserSession.clearSession();

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Conta excluída com sucesso!'),
                            backgroundColor: Colors.green,
                          ),
                        );

                        // 4. Redireciona para a tela de Login
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/login',
                          (route) => false,
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Falha ao excluir conta!'),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                      }
                    } catch (e) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Erro ao excluir conta: $e'),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                    } finally {
                      if (mounted) {
                        setState(() => _isLoading = false);
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.redAccent,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Excluir Perfil'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
