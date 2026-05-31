import 'package:hive_flutter/hive_flutter.dart';
import '../models/cv_data.dart';
import 'cv_repository.dart';

class HiveCVRepository implements CVRepository {
  static const _boxName = 'cvs';
  static const _seedVersionKey = '__seed_version__';
  late final Box<String> _box;

  Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox<String>(_boxName);
  }

  @override
  List<CVData> loadAll() {
    final list = _box.keys
        .where((key) => !key.startsWith('__'))
        .map((key) {
          try {
            final json = _box.get(key);
            if (json == null) return null;
            return CVData.fromJsonString(json);
          } catch (_) {
            return null;
          }
        })
        .whereType<CVData>()
        .toList();
    list.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return list;
  }

  @override
  CVData? getById(String id) {
    try {
      final json = _box.get(id);
      if (json == null) return null;
      return CVData.fromJsonString(json);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> save(CVData cv) async {
    await _box.put(cv.id, cv.toJsonString());
  }

  @override
  Future<void> delete(String id) async {
    await _box.delete(id);
  }

  @override
  Future<void> deleteAll() async {
    await _box.clear();
  }

  @override
  String duplicate(String id) {
    final original = getById(id);
    if (original == null) return '';
    final copy = CVData(
      title: '${original.title} (Copy)',
      templateId: original.templateId,
      primaryColor: original.primaryColor,
      showPhoto: original.showPhoto,
      showSummary: original.showSummary,
      showExperience: original.showExperience,
      showEducation: original.showEducation,
      showSkills: original.showSkills,
      showLanguages: original.showLanguages,
      showProjects: original.showProjects,
      showCertifications: original.showCertifications,
      personalInfo: original.personalInfo.copyWith(),
      summary: original.summary,
      experiences: original.experiences.map((e) => e.copyWith()).toList(),
      educations: original.educations.map((e) => e.copyWith()).toList(),
      skills: original.skills.map((e) => e.copyWith()).toList(),
      languages: original.languages.map((e) => e.copyWith()).toList(),
      projects: original.projects.map((e) => e.copyWith()).toList(),
      certifications: original.certifications.map((e) => e.copyWith()).toList(),
    );
    save(copy);
    return copy.id;
  }

  int getSeedVersion() {
    final v = _box.get(_seedVersionKey);
    if (v == null) return 0;
    return int.tryParse(v) ?? 0;
  }

  Future<void> setSeedVersion(int version) async {
    await _box.put(_seedVersionKey, version.toString());
  }
}
