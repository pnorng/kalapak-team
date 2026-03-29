class PostModel {
  final int id;
  final String title;
  final String slug;
  final String? content;
  final String? thumbnail;
  final List<String> images;
  final String? category;
  final int? authorId;
  final String? authorName;
  final String? authorAvatar;
  final bool isPublished;
  final int likesCount;
  final int commentsCount;
  final DateTime createdAt;

  const PostModel({
    required this.id,
    required this.title,
    required this.slug,
    this.content,
    this.thumbnail,
    this.images = const [],
    this.category,
    this.authorId,
    this.authorName,
    this.authorAvatar,
    this.isPublished = true,
    this.likesCount = 0,
    this.commentsCount = 0,
    required this.createdAt,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    final author = json['author'] as Map<String, dynamic>?;
    return PostModel(
      id: json['id'] as int,
      title: json['title'] as String,
      slug: json['slug'] as String,
      content: json['content'] as String?,
      thumbnail: json['thumbnail'] as String?,
      images: (json['images'] as List<dynamic>?)?.cast<String>() ?? [],
      category: json['category'] as String?,
      authorId: author != null ? author['id'] as int? : null,
      authorName: author != null ? author['name'] as String? : null,
      authorAvatar: author != null ? author['avatar'] as String? : null,
      isPublished: (json['is_published'] as bool?) ?? true,
      likesCount: (json['likes_count'] as int?) ?? 0,
      commentsCount: (json['comments_count'] as int?) ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
