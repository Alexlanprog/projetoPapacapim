class UserModel {
  final String login;
  final String name;
  final String senha;
  final String senhaConfirmada;

  UserModel({
    required this.name,
    required this.login,
    required this.senha,
    required this.senhaConfirmada,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      login: json['login'] ?? '',
      name: json['name'] ?? '',
      senha: '',
      senhaConfirmada: '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'login': login,
      'name': name,
      'password': senha,
      'password_confirmation': senhaConfirmada,
    };
  }
}
