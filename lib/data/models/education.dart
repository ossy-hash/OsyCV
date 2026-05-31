class Education {
  String id;
  String institution;
  String degree;
  String field;
  DateTime? startDate;
  DateTime? endDate;
  double? gpa;
  String description;

  Education({
    String? id,
    this.institution = '',
    this.degree = '',
    this.field = '',
    this.startDate,
    this.endDate,
    this.gpa,
    this.description = '',
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  Education copyWith({
    String? institution,
    String? degree,
    String? field,
    DateTime? startDate,
    DateTime? endDate,
    double? gpa,
    String? description,
  }) =>
      Education(
        id: id,
        institution: institution ?? this.institution,
        degree: degree ?? this.degree,
        field: field ?? this.field,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        gpa: gpa ?? this.gpa,
        description: description ?? this.description,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'institution': institution,
        'degree': degree,
        'field': field,
        'startDate': startDate?.toIso8601String(),
        'endDate': endDate?.toIso8601String(),
        'gpa': gpa,
        'description': description,
      };

  factory Education.fromJson(Map<String, dynamic> json) => Education(
        id: json['id'] as String?,
        institution: json['institution'] as String? ?? '',
        degree: json['degree'] as String? ?? '',
        field: json['field'] as String? ?? '',
        startDate: json['startDate'] != null ? DateTime.parse(json['startDate'] as String) : null,
        endDate: json['endDate'] != null ? DateTime.parse(json['endDate'] as String) : null,
        gpa: (json['gpa'] as num?)?.toDouble(),
        description: json['description'] as String? ?? '',
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Education &&
          id == other.id &&
          institution == other.institution &&
          degree == other.degree &&
          field == other.field &&
          startDate == other.startDate &&
          endDate == other.endDate &&
          gpa == other.gpa &&
          description == other.description;

  @override
  int get hashCode => Object.hash(id, institution, degree, field, startDate, endDate, gpa, description);
}
