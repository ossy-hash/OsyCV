class Experience {
  String id;
  String company;
  String position;
  DateTime? startDate;
  DateTime? endDate;
  bool current;
  String description;
  List<String> highlights;

  Experience({
    String? id,
    this.company = '',
    this.position = '',
    this.startDate,
    this.endDate,
    this.current = false,
    this.description = '',
    List<String>? highlights,
  })  : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        highlights = highlights ?? [];

  Experience copyWith({
    String? company,
    String? position,
    DateTime? startDate,
    DateTime? endDate,
    bool? current,
    String? description,
    List<String>? highlights,
  }) =>
      Experience(
        id: id,
        company: company ?? this.company,
        position: position ?? this.position,
        startDate: startDate ?? this.startDate,
        endDate: current == true ? null : (endDate ?? this.endDate),
        current: current ?? this.current,
        description: description ?? this.description,
        highlights: highlights ?? List.from(this.highlights),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'company': company,
        'position': position,
        'startDate': startDate?.toIso8601String(),
        'endDate': endDate?.toIso8601String(),
        'current': current,
        'description': description,
        'highlights': highlights,
      };

  factory Experience.fromJson(Map<String, dynamic> json) => Experience(
        id: json['id'] as String?,
        company: json['company'] as String? ?? '',
        position: json['position'] as String? ?? '',
        startDate: json['startDate'] != null ? DateTime.parse(json['startDate'] as String) : null,
        endDate: json['endDate'] != null ? DateTime.parse(json['endDate'] as String) : null,
        current: json['current'] as bool? ?? false,
        description: json['description'] as String? ?? '',
        highlights: (json['highlights'] as List<dynamic>?)?.cast<String>().toList() ?? [],
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Experience &&
          id == other.id &&
          company == other.company &&
          position == other.position &&
          startDate == other.startDate &&
          endDate == other.endDate &&
          current == other.current &&
          description == other.description &&
          _listEquals(highlights, other.highlights);

  @override
  int get hashCode =>
      Object.hash(id, company, position, startDate, endDate, current, description);

  static bool _listEquals(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
