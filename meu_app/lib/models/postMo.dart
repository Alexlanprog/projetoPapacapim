class PostModel {
  final int? id;
  final String userLogin;
  final String content;
  final String? createdAt;
  final int likesCount;
  final bool youLiked;

  PostModel({
    this.id,
    required this.userLogin,
    required this.content,
    this.createdAt,
    this.likesCount = 0,
    this.youLiked = false,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      userLogin: json['user_login'] ?? json['user']?['login'] ?? '',
      content: json['content'] ?? json['message'] ?? '',
      createdAt: json['created_at'],
      likesCount: json['likes_number'] ?? 0,
      youLiked: json['you_liked'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'post': {'message': content},
    };
  }
}
