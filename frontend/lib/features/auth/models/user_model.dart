class UserModel {
  final int id;
  final String name;
  final String email;
  final String role;
  final String? avatar;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.avatar,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] as int,
        name: json['name'] as String,
        email: json['email'] as String,
        role: json['role'] as String,
        avatar: json['avatar'] as String?,
      );

  bool get isAdmin => role == 'admin';
  bool get isUser => role == 'user' || role == 'admin';
}
