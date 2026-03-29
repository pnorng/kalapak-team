class ProjectModel {
  final int id;
  final String title;
  final String? description;
  final String? coverImage;
  final List<String> techStack;
  final String? githubUrl;
  final String? liveUrl;
  final bool isFeatured;

  const ProjectModel({
    required this.id,
    required this.title,
    this.description,
    this.coverImage,
    this.techStack = const [],
    this.githubUrl,
    this.liveUrl,
    this.isFeatured = false,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) => ProjectModel(
        id: json['id'] as int,
        title: json['title'] as String,
        description: json['description'] as String?,
        coverImage: json['cover_image'] as String?,
        techStack: (json['tech_stack'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            [],
        githubUrl: json['github_url'] as String?,
        liveUrl: json['live_url'] as String?,
        isFeatured: json['is_featured'] as bool? ?? false,
      );
}
