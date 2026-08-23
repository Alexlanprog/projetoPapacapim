class UserModel {
  final int id;
  final String nome;
  final String email;
  final String senha;
  final String senhaConfirmada;

  UserModel({
    required this.id,
    required this.nome,
    required this.email,
    required this.senha,
    required this.senhaConfirmada,
  });

  factory UserModel.fromjson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      nome: json['nome'],
      email: json['email'],
      senha: json['senha'],
      senhaConfirmada: json['senha_confirmada'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'senha': senha,
      'senhaConfirmada': senhaConfirmada,
    };
  }
}
