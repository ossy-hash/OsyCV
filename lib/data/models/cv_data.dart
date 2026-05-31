import 'dart:convert';
import 'certification.dart';
import 'education.dart';
import 'experience.dart';
import 'language.dart';
import 'personal_info.dart';
import 'project.dart';
import 'skill.dart';

export 'certification.dart';
export 'education.dart';
export 'experience.dart';
export 'language.dart';
export 'personal_info.dart';
export 'project.dart';
export 'skill.dart';

class CVData {
  String id;
  String title;
  DateTime createdAt;
  DateTime updatedAt;
  String templateId;
  int primaryColor;
  bool showPhoto;
  bool showSummary;
  bool showExperience;
  bool showEducation;
  bool showSkills;
  bool showLanguages;
  bool showProjects;
  bool showCertifications;

  PersonalInfo personalInfo;
  String summary;
  List<Experience> experiences;
  List<Education> educations;
  List<Skill> skills;
  List<Language> languages;
  List<Project> projects;
  List<Certification> certifications;

  CVData({
    String? id,
    String? title,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.templateId = 'classic',
    this.primaryColor = 0xFF6C63FF,
    this.showPhoto = true,
    this.showSummary = true,
    this.showExperience = true,
    this.showEducation = true,
    this.showSkills = true,
    this.showLanguages = true,
    this.showProjects = true,
    this.showCertifications = true,
    PersonalInfo? personalInfo,
    this.summary = '',
    List<Experience>? experiences,
    List<Education>? educations,
    List<Skill>? skills,
    List<Language>? languages,
    List<Project>? projects,
    List<Certification>? certifications,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        title = title ?? 'Untitled CV',
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now(),
        personalInfo = personalInfo ?? PersonalInfo(),
        experiences = experiences ?? [],
        educations = educations ?? [],
        skills = skills ?? [],
        languages = languages ?? [],
        projects = projects ?? [],
        certifications = certifications ?? [];

  CVData copyWith({
    String? title,
    String? templateId,
    int? primaryColor,
    bool? showPhoto,
    bool? showSummary,
    bool? showExperience,
    bool? showEducation,
    bool? showSkills,
    bool? showLanguages,
    bool? showProjects,
    bool? showCertifications,
    PersonalInfo? personalInfo,
    String? summary,
    List<Experience>? experiences,
    List<Education>? educations,
    List<Skill>? skills,
    List<Language>? languages,
    List<Project>? projects,
    List<Certification>? certifications,
  }) {
    return CVData(
      id: id,
      title: title ?? this.title,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      templateId: templateId ?? this.templateId,
      primaryColor: primaryColor ?? this.primaryColor,
      showPhoto: showPhoto ?? this.showPhoto,
      showSummary: showSummary ?? this.showSummary,
      showExperience: showExperience ?? this.showExperience,
      showEducation: showEducation ?? this.showEducation,
      showSkills: showSkills ?? this.showSkills,
      showLanguages: showLanguages ?? this.showLanguages,
      showProjects: showProjects ?? this.showProjects,
      showCertifications: showCertifications ?? this.showCertifications,
      personalInfo: personalInfo ?? this.personalInfo,
      summary: summary ?? this.summary,
      experiences: experiences ?? this.experiences,
      educations: educations ?? this.educations,
      skills: skills ?? this.skills,
      languages: languages ?? this.languages,
      projects: projects ?? this.projects,
      certifications: certifications ?? this.certifications,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'templateId': templateId,
        'primaryColor': primaryColor,
        'showPhoto': showPhoto,
        'showSummary': showSummary,
        'showExperience': showExperience,
        'showEducation': showEducation,
        'showSkills': showSkills,
        'showLanguages': showLanguages,
        'showProjects': showProjects,
        'showCertifications': showCertifications,
        'personalInfo': personalInfo.toJson(),
        'summary': summary,
        'experiences': experiences.map((e) => e.toJson()).toList(),
        'educations': educations.map((e) => e.toJson()).toList(),
        'skills': skills.map((e) => e.toJson()).toList(),
        'languages': languages.map((e) => e.toJson()).toList(),
        'projects': projects.map((e) => e.toJson()).toList(),
        'certifications': certifications.map((e) => e.toJson()).toList(),
      };

  factory CVData.fromJson(Map<String, dynamic> json) => CVData(
        id: json['id'] as String?,
        title: json['title'] as String? ?? 'Untitled CV',
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
        templateId: json['templateId'] as String? ?? 'classic',
        primaryColor: json['primaryColor'] as int? ?? 0xFF6C63FF,
        showPhoto: json['showPhoto'] as bool? ?? true,
        showSummary: json['showSummary'] as bool? ?? true,
        showExperience: json['showExperience'] as bool? ?? true,
        showEducation: json['showEducation'] as bool? ?? true,
        showSkills: json['showSkills'] as bool? ?? true,
        showLanguages: json['showLanguages'] as bool? ?? true,
        showProjects: json['showProjects'] as bool? ?? true,
        showCertifications: json['showCertifications'] as bool? ?? true,
        personalInfo: PersonalInfo.fromJson(json['personalInfo'] as Map<String, dynamic>? ?? {}),
        summary: json['summary'] as String? ?? '',
        experiences: (json['experiences'] as List<dynamic>?)
                ?.map((e) => Experience.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        educations: (json['educations'] as List<dynamic>?)
                ?.map((e) => Education.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        skills: (json['skills'] as List<dynamic>?)
                ?.map((e) => Skill.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        languages: (json['languages'] as List<dynamic>?)
                ?.map((e) => Language.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        projects: (json['projects'] as List<dynamic>?)
                ?.map((e) => Project.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        certifications: (json['certifications'] as List<dynamic>?)
                ?.map((e) => Certification.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
      );

  String toJsonString() => jsonEncode(toJson());

  factory CVData.fromJsonString(String str) => CVData.fromJson(jsonDecode(str) as Map<String, dynamic>);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CVData && id == other.id && updatedAt == other.updatedAt;

  @override
  int get hashCode => id.hashCode;
}
