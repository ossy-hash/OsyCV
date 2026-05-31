class Skill {
  String id;
  String name;
  String category;
  int level;

  Skill({
    String? id,
    this.name = '',
    this.category = 'Technical',
    this.level = 3,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  Skill copyWith({
    String? name,
    String? category,
    int? level,
  }) =>
      Skill(
        id: id,
        name: name ?? this.name,
        category: category ?? this.category,
        level: level ?? this.level,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'category': category,
        'level': level,
      };

  factory Skill.fromJson(Map<String, dynamic> json) => Skill(
        id: json['id'] as String?,
        name: json['name'] as String? ?? '',
        category: json['category'] as String? ?? 'Technical',
        level: json['level'] as int? ?? 3,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Skill &&
          id == other.id &&
          name == other.name &&
          category == other.category &&
          level == other.level;

  @override
  int get hashCode => Object.hash(id, name, category, level);
}
