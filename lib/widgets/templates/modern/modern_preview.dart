import 'package:flutter/material.dart';
import '../../../data/models/cv_data.dart';
import '../mixins/preview_section_renderers.dart';

class ModernPreview with PreviewSectionRenderers {
  final CVData cv;
  ModernPreview({required this.cv});

  Color get accent => Color(cv.primaryColor);

  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeader(),
          _buildBody(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final p = cv.personalInfo;
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [accent, accent.withValues(alpha: 0.7)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(p.fullName, style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold, color: Colors.white)),
          if (p.jobTitle.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 8),
              child: Text(p.jobTitle.toUpperCase(), style: const TextStyle(fontSize: 14, color: Colors.white70, letterSpacing: 1.5)),
            ),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              if (p.email.isNotEmpty) Text(p.email, style: const TextStyle(fontSize: 11, color: Colors.white70)),
              if (p.email.isNotEmpty && p.phone.isNotEmpty) const Text('|', style: TextStyle(fontSize: 11, color: Colors.white70)),
              if (p.phone.isNotEmpty) Text(p.phone, style: const TextStyle(fontSize: 11, color: Colors.white70)),
              if (p.phone.isNotEmpty && (p.linkedIn.isNotEmpty || p.github.isNotEmpty)) const Text('|', style: TextStyle(fontSize: 11, color: Colors.white70)),
              if (p.linkedIn.isNotEmpty) Text(p.linkedIn, style: const TextStyle(fontSize: 11, color: Colors.white70)),
              if (p.linkedIn.isNotEmpty && p.github.isNotEmpty) const Text('|', style: TextStyle(fontSize: 11, color: Colors.white70)),
              if (p.github.isNotEmpty) Text(p.github, style: const TextStyle(fontSize: 11, color: Colors.white70)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(24),
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
            ...cv.experiences.map((e) => previewExperienceItem(e, accent)),
          ],
          if (cv.showEducation && cv.educations.isNotEmpty) ...[
            _sectionHeader('Education'),
            ...cv.educations.map((e) => previewEducationItem(e)),
          ],
          if (cv.showSkills && cv.skills.where((s) => s.name.isNotEmpty).isNotEmpty) ...[
            _sectionHeader('Skills'),
            const SizedBox(height: 4),
            previewSkillChips(cv.skills, accent),
            const SizedBox(height: 12),
          ],
          if (cv.showLanguages && cv.languages.where((l) => l.name.isNotEmpty).isNotEmpty) ...[
            _sectionHeader('Languages'),
            previewLanguageChips(cv.languages, accent),
            const SizedBox(height: 8),
          ],
          if (cv.showProjects && cv.projects.isNotEmpty) ...[
            _sectionHeader('Projects'),
            ...cv.projects.map((p) => previewProjectItem(p, accent)),
          ],
          if (cv.showCertifications && cv.certifications.isNotEmpty) ...[
            _sectionHeader('Certifications'),
            ...cv.certifications.map((c) => previewCertificationItem(c)),
          ],
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title.toUpperCase(), style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: accent, letterSpacing: 1.2)),
        Container(margin: const EdgeInsets.only(top: 2, bottom: 10), width: 30, height: 2, color: accent),
      ],
    );
  }
}
