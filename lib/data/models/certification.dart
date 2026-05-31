class Certification {
  String id;
  String name;
  String issuer;
  DateTime? date;
  String url;

  Certification({
    String? id,
    this.name = '',
    this.issuer = '',
    this.date,
    this.url = '',
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  Certification copyWith({
    String? name,
    String? issuer,
    DateTime? date,
    String? url,
  }) =>
      Certification(
        id: id,
        name: name ?? this.name,
        issuer: issuer ?? this.issuer,
        date: date ?? this.date,
        url: url ?? this.url,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'issuer': issuer,
        'date': date?.toIso8601String(),
        'url': url,
      };

  factory Certification.fromJson(Map<String, dynamic> json) => Certification(
        id: json['id'] as String?,
        name: json['name'] as String? ?? '',
        issuer: json['issuer'] as String? ?? '',
        date: json['date'] != null ? DateTime.parse(json['date'] as String) : null,
        url: json['url'] as String? ?? '',
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Certification &&
          id == other.id &&
          name == other.name &&
          issuer == other.issuer &&
          date == other.date &&
          url == other.url;

  @override
  int get hashCode => Object.hash(id, name, issuer, date, url);
}
