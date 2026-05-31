import 'package:flutter/material.dart';
import '../../../data/models/cv_data.dart';
import '../mixins/preview_section_renderers.dart';

class ExecutivePreview with PreviewSectionRenderers {
  final CVData cv;
  ExecutivePreview({required this.cv});

  static const _navy = Color(0xFF1A1A2E);
  static const _gold = Color(0xFFC8A951);

  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 140, child: _sidebar()),
        Expanded(child: _main()),
      ],
    );
  }

  Widget _sidebar() {
    final p = cv.personalInfo;
    return Container(
      padding: const EdgeInsets.all(12),
      height: double.infinity,
      color: _navy,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(p.fullName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _gold)),
          if (p.jobTitle.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(p.jobTitle, style: const TextStyle(fontSize: 11, color: Colors.white70)),
          ],
          const SizedBox(height: 12),
          if (p.email.isNotEmpty) Text(p.email, style: const TextStyle(fontSize: 10, color: Colors.white70)),
          if (p.phone.isNotEmpty) Text(p.phone, style: const TextStyle(fontSize: 10, color: Colors.white70)),
          if (p.linkedIn.isNotEmpty) Text(p.linkedIn, style: const TextStyle(fontSize: 10, color: Colors.white70)),
          if (p.github.isNotEmpty) Text(p.github, style: const TextStyle(fontSize: 10, color: Colors.white70)),
          if (p.portfolio.isNotEmpty) Text(p.portfolio, style: const TextStyle(fontSize: 10, color: Colors.white70)),
          if (p.address.isNotEmpty) Text(p.address, style: const TextStyle(fontSize: 10, color: Colors.white70)),
          if (cv.showSkills && cv.skills.where((s) => s.name.isNotEmpty && s.level >= 4).isNotEmpty) ...[
            const SizedBox(height: 12),
            const Text('CORE SKILLS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: _gold, letterSpacing: 1.5)),
            const SizedBox(height: 4),
            ...cv.skills.where((s) => s.name.isNotEmpty && s.level >= 4).map((s) => Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Text(s.name, style: const TextStyle(fontSize: 10, color: Colors.white)),
            )),
          ],
          if (cv.showLanguages && cv.languages.where((l) => l.name.isNotEmpty).isNotEmpty) ...[
            const SizedBox(height: 12),
            const Text('LANGUAGES', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: _gold, letterSpacing: 1.5)),
            const SizedBox(height: 4),
            ...cv.languages.where((l) => l.name.isNotEmpty).map((l) => Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Text('${l.name} (${l.level})', style: const TextStyle(fontSize: 10, color: Colors.white)),
            )),
          ],
          if (cv.showCertifications && cv.certifications.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Text('CERTIFICATIONS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: _gold, letterSpacing: 1.5)),
            const SizedBox(height: 4),
            ...cv.certifications.map((c) => Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Text(c.name, style: const TextStyle(fontSize: 10, color: Colors.white)),
            )),
          ],
        ],
      ),
    );
  }

  Widget _main() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (cv.showSummary && cv.summary.isNotEmpty) ...[
              _sectionHeader('Professional Summary'),
              Text(cv.summary, style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
              const SizedBox(height: 12),
            ],
            if (cv.showExperience && cv.experiences.isNotEmpty) ...[
              _sectionHeader('Experience'),
              ...cv.experiences.map((e) => previewExperienceItem(e, _navy)),
            ],
            if (cv.showEducation && cv.educations.isNotEmpty) ...[
              _sectionHeader('Education'),
              ...cv.educations.map((e) => previewEducationItem(e)),
            ],
            if (cv.showProjects && cv.projects.isNotEmpty) ...[
              _sectionHeader('Projects'),
              ...cv.projects.map((p) => previewProjectItem(p, _navy)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title.toUpperCase(), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: _navy, letterSpacing: 1.2)),
        Container(margin: const EdgeInsets.only(top: 2, bottom: 10), width: 40, height: 1.5, color: _gold),
      ],
    );
  }
}
