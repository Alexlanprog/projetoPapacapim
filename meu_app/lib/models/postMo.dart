class PostModel {
  final int? id;
  final String userLogin;
  final String content;
  final String? createdAt;

  PostModel({
    this.id,
    required this.userLogin,
    required this.content,
    this.createdAt,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      userLogin: json['user_login'] ?? json['user']?['login'] ?? '',
      content: json['content'] ?? json['message'] ?? '',
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'post': {'message': content},
    };
  }
}
