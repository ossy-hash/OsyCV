class Project {
  String id;
  String name;
  String description;
  String techStack;
  String url;
  DateTime? startDate;
  DateTime? endDate;

  Project({
    String? id,
    this.name = '',
    this.description = '',
    this.techStack = '',
    this.url = '',
    this.startDate,
    this.endDate,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  Project copyWith({
    String? name,
    String? description,
    String? techStack,
    String? url,
    DateTime? startDate,
    DateTime? endDate,
  }) =>
      Project(
        id: id,
        name: name ?? this.name,
        description: description ?? this.description,
        techStack: techStack ?? this.techStack,
        url: url ?? this.url,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'techStack': techStack,
        'url': url,
        'startDate': startDate?.toIso8601String(),
        'endDate': endDate?.toIso8601String(),
      };

  factory Project.fromJson(Map<String, dynamic> json) => Project(
        id: json['id'] as String?,
        name: json['name'] as String? ?? '',
        description: json['description'] as String? ?? '',
        techStack: json['techStack'] as String? ?? '',
        url: json['url'] as String? ?? '',
        startDate: json['startDate'] != null ? DateTime.parse(json['startDate'] as String) : null,
        endDate: json['endDate'] != null ? DateTime.parse(json['endDate'] as String) : null,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Project &&
          id == other.id &&
          name == other.name &&
          description == other.description &&
          techStack == other.techStack &&
          url == other.url &&
          startDate == other.startDate &&
          endDate == other.endDate;

  @override
  int get hashCode => Object.hash(id, name, description, techStack, url, startDate, endDate);
}
