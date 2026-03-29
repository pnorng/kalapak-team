class CommentModel {
  final int id;
  final int postId;
  final int userId;
  final String userName;
  final String? userAvatar;
  final String content;
  final DateTime createdAt;

  const CommentModel({
    required this.id,
    required this.postId,
    required this.userId,
    required this.userName,
    this.userAvatar,
    required this.content,
    required this.createdAt,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>?;
    return CommentModel(
      id: json['id'] as int,
      postId: json['post_id'] as int,
      userId: (user?['id'] ?? json['user_id']) as int,
      userName: (user?['name'] ?? 'Unknown') as String,
      userAvatar: user?['avatar'] as String?,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
