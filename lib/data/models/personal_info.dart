class PersonalInfo {
  String fullName;
  String email;
  String phone;
  String linkedIn;
  String github;
  String portfolio;
  String address;
  String jobTitle;
  String photoPath;
  String nationality;

  PersonalInfo({
    this.fullName = '',
    this.email = '',
    this.phone = '',
    this.linkedIn = '',
    this.github = '',
    this.portfolio = '',
    this.address = '',
    this.jobTitle = '',
    this.photoPath = '',
    this.nationality = '',
  });

  PersonalInfo copyWith({
    String? fullName,
    String? email,
    String? phone,
    String? linkedIn,
    String? github,
    String? portfolio,
    String? address,
    String? jobTitle,
    String? photoPath,
    String? nationality,
  }) =>
      PersonalInfo(
        fullName: fullName ?? this.fullName,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        linkedIn: linkedIn ?? this.linkedIn,
        github: github ?? this.github,
        portfolio: portfolio ?? this.portfolio,
        address: address ?? this.address,
        jobTitle: jobTitle ?? this.jobTitle,
        photoPath: photoPath ?? this.photoPath,
        nationality: nationality ?? this.nationality,
      );

  Map<String, dynamic> toJson() => {
        'fullName': fullName,
        'email': email,
        'phone': phone,
        'linkedIn': linkedIn,
        'github': github,
        'portfolio': portfolio,
        'address': address,
        'jobTitle': jobTitle,
        'photoPath': photoPath,
        'nationality': nationality,
      };

  factory PersonalInfo.fromJson(Map<String, dynamic> json) => PersonalInfo(
        fullName: json['fullName'] as String? ?? '',
        email: json['email'] as String? ?? '',
        phone: json['phone'] as String? ?? '',
        linkedIn: json['linkedIn'] as String? ?? '',
        github: json['github'] as String? ?? '',
        portfolio: json['portfolio'] as String? ?? '',
        address: json['address'] as String? ?? '',
        jobTitle: json['jobTitle'] as String? ?? '',
        photoPath: json['photoPath'] as String? ?? '',
        nationality: json['nationality'] as String? ?? '',
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PersonalInfo &&
          fullName == other.fullName &&
          email == other.email &&
          phone == other.phone &&
          linkedIn == other.linkedIn &&
          github == other.github &&
          portfolio == other.portfolio &&
          address == other.address &&
          jobTitle == other.jobTitle &&
          photoPath == other.photoPath &&
          nationality == other.nationality;

  @override
  int get hashCode =>
      Object.hash(fullName, email, phone, linkedIn, github, portfolio, address, jobTitle, photoPath, nationality);
}
