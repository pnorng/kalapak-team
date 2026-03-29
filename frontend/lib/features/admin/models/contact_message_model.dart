class ContactMessageModel {
  final int id;
  final String name;
  final String email;
  final String subject;
  final String message;
  final bool isRead;
  final DateTime? createdAt;

  const ContactMessageModel({
    required this.id,
    required this.name,
    required this.email,
    required this.subject,
    required this.message,
    required this.isRead,
    this.createdAt,
  });

  factory ContactMessageModel.fromJson(Map<String, dynamic> json) {
    return ContactMessageModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      subject: json['subject'] as String? ?? '',
      message: json['message'] as String? ?? '',
      isRead: json['is_read'] == true || json['is_read'] == 1,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
    );
  }
}
