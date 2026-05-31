import 'package:flutter/material.dart';
import '../../../data/models/cv_data.dart';
import '../mixins/preview_section_renderers.dart';

class MinimalPreview with PreviewSectionRenderers {
  final CVData cv;
  MinimalPreview({required this.cv});

  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(),
          if (cv.showSummary && cv.summary.isNotEmpty) ...[
            _sectionHeader('Professional Summary'),
            Text(cv.summary, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
            const SizedBox(height: 12),
          ],
          if (cv.showExperience && cv.experiences.isNotEmpty) ...[
            _sectionHeader('Experience'),
            ...cv.experiences.map((e) => previewExperienceItem(e, Colors.grey, bulletColor: Colors.grey)),
          ],
          if (cv.showEducation && cv.educations.isNotEmpty) ...[
            _sectionHeader('Education'),
            ...cv.educations.map((e) => previewEducationItem(e)),
          ],
          if (cv.showSkills && cv.skills.where((s) => s.name.isNotEmpty).isNotEmpty) ...[
            _sectionHeader('Skills'),
            previewLanguageInline(cv.skills.map((s) => Language(name: s.name, level: '')).toList()),
          ],
          if (cv.showLanguages && cv.languages.where((l) => l.name.isNotEmpty).isNotEmpty) ...[
            _sectionHeader('Languages'),
            previewLanguageInline(cv.languages),
          ],
          if (cv.showProjects && cv.projects.isNotEmpty) ...[
            _sectionHeader('Projects'),
            ...cv.projects.map((p) => previewProjectItem(p, Colors.grey)),
          ],
          if (cv.showCertifications && cv.certifications.isNotEmpty) ...[
            _sectionHeader('Certifications'),
            ...cv.certifications.map((c) => previewCertificationItem(c)),
          ],
        ],
      ),
    );
  }

  Widget _header() {
    final p = cv.personalInfo;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(p.fullName, style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w300, letterSpacing: 3)),
        if (p.jobTitle.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(p.jobTitle.toUpperCase(), style: const TextStyle(fontSize: 13, color: Colors.grey, letterSpacing: 1.5)),
          ),
        const SizedBox(height: 4),
        Wrap(
          spacing: 6,
          runSpacing: 4,
          children: [
            if (p.email.isNotEmpty) Text(p.email, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            if (p.email.isNotEmpty && p.phone.isNotEmpty) Text(' / ', style: const TextStyle(fontSize: 12, color: Colors.grey)),
            if (p.phone.isNotEmpty) Text(p.phone, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            if (p.phone.isNotEmpty && (p.linkedIn.isNotEmpty || p.github.isNotEmpty)) Text(' / ', style: const TextStyle(fontSize: 12, color: Colors.grey)),
            if (p.linkedIn.isNotEmpty) Text(p.linkedIn, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            if (p.linkedIn.isNotEmpty && p.github.isNotEmpty) Text(' / ', style: const TextStyle(fontSize: 12, color: Colors.grey)),
            if (p.github.isNotEmpty) Text(p.github, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
        const Divider(height: 24),
      ],
    );
  }

  Widget _sectionHeader(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title.toUpperCase(), style: const TextStyle(fontSize: 11, color: Colors.grey, letterSpacing: 2)),
        const Divider(height: 16),
      ],
    );
  }
}
