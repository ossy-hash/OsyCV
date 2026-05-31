class Language {
  String id;
  String name;
  String level;

  Language({
    String? id,
    this.name = '',
    this.level = 'B1 - Intermediate',
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  Language copyWith({
    String? name,
    String? level,
  }) =>
      Language(
        id: id,
        name: name ?? this.name,
        level: level ?? this.level,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'level': level,
      };

  factory Language.fromJson(Map<String, dynamic> json) => Language(
        id: json['id'] as String?,
        name: json['name'] as String? ?? '',
        level: json['level'] as String? ?? 'B1 - Intermediate',
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Language && id == other.id && name == other.name && level == other.level;

  @override
  int get hashCode => Object.hash(id, name, level);
}
