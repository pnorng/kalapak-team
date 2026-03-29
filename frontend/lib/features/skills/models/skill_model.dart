class SkillModel {
  final int id;
  final String name;
  final String? iconUrl;
  final String? category;
  final int sortOrder;

  const SkillModel({
    required this.id,
    required this.name,
    this.iconUrl,
    this.category,
    this.sortOrder = 0,
  });

  factory SkillModel.fromJson(Map<String, dynamic> json) => SkillModel(
        id: json['id'] as int,
        name: json['name'] as String,
        iconUrl: json['icon_url'] as String?,
        category: json['category'] as String?,
        sortOrder: json['sort_order'] as int? ?? 0,
      );
}
