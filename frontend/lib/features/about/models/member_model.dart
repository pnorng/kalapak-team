class MemberModel {
  final int id;
  final String name;
  final String role;
  final String? bio;
  final String? avatar;
  final String? githubUrl;
  final String? linkedinUrl;
  final String? email;

  const MemberModel({
    required this.id,
    required this.name,
    required this.role,
    this.bio,
    this.avatar,
    this.githubUrl,
    this.linkedinUrl,
    this.email,
  });

  factory MemberModel.fromJson(Map<String, dynamic> json) => MemberModel(
        id: json['id'] as int,
        name: json['name'] as String,
        role: json['role'] as String,
        bio: json['bio'] as String?,
        avatar: json['avatar'] as String?,
        githubUrl: json['github_url'] as String?,
        linkedinUrl: json['linkedin_url'] as String?,
        email: json['email'] as String?,
      );
}
