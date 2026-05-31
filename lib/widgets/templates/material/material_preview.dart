import 'package:flutter/material.dart';
import '../../../data/models/cv_data.dart';
import '../mixins/preview_section_renderers.dart';

class MaterialPreview with PreviewSectionRenderers {
  final CVData cv;
  MaterialPreview({required this.cv});

  Color get accent => Color(cv.primaryColor);

  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          if (cv.showSummary && cv.summary.isNotEmpty)
            _sectionCard([
              _sectionTitle('Professional Summary'),
              Text(cv.summary, style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
            ]),
          if (cv.showExperience && cv.experiences.isNotEmpty)
            _sectionCard([
              _sectionTitle('Experience'),
              ...cv.experiences.map((e) => _timelineItem(e)),
            ]),
          if (cv.showEducation && cv.educations.isNotEmpty)
            _sectionCard([
              _sectionTitle('Education'),
              ...cv.educations.map((e) => _iconItem(Icons.school, previewEducationItem(e))),
            ]),
          if (cv.showSkills && cv.skills.where((s) => s.name.isNotEmpty).isNotEmpty)
            _sectionCard([
              _sectionTitle('Skills'),
              const SizedBox(height: 4),
              previewSkillChips(cv.skills, accent),
            ]),
          if (cv.showLanguages && cv.languages.where((l) => l.name.isNotEmpty).isNotEmpty)
            _sectionCard([
              _sectionTitle('Languages'),
              previewLanguageChips(cv.languages, accent),
            ]),
          if (cv.showProjects && cv.projects.isNotEmpty)
            _sectionCard([
              _sectionTitle('Projects'),
              ...cv.projects.map((p) => _iconItem(Icons.folder_outlined, previewProjectItem(p, accent))),
            ]),
          if (cv.showCertifications && cv.certifications.isNotEmpty)
            _sectionCard([
              _sectionTitle('Certifications'),
              ...cv.certifications.map((c) => _iconItem(Icons.verified_outlined, previewCertificationItem(c))),
            ]),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final p = cv.personalInfo;
    final initials = p.fullName.isNotEmpty ? p.fullName[0].toUpperCase() : '?';
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [accent, accent.withValues(alpha: 0.7)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: Colors.white.withValues(alpha: 0.2),
                child: Text(initials, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(p.fullName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                  if (p.jobTitle.isNotEmpty)
                    Text(p.jobTitle, style: const TextStyle(fontSize: 13, color: Colors.white70)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            runSpacing: 4,
            children: [
              if (p.email.isNotEmpty) _headerChip(Icons.email_outlined, p.email),
              if (p.phone.isNotEmpty) _headerChip(Icons.phone_outlined, p.phone),
              if (p.linkedIn.isNotEmpty) _headerChip(Icons.link, p.linkedIn),
              if (p.github.isNotEmpty) _headerChip(Icons.code, p.github),
            ],
          ),
        ],
      ),
    );
  }

  Widget _headerChip(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: Colors.white70),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 10, color: Colors.white70)),
      ],
    );
  }

  Widget _sectionCard(List<Widget> children) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(width: 4, height: 16, decoration: BoxDecoration(
            color: accent, borderRadius: BorderRadius.circular(2),
          )),
          const SizedBox(width: 8),
          Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: accent)),
        ],
      ),
    );
  }

  Widget _timelineItem(Experience e) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(width: 10, height: 10, decoration: BoxDecoration(color: accent, shape: BoxShape.circle)),
              Container(width: 1, height: 40, color: accent.withValues(alpha: 0.3)),
            ],
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(e.position, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                if (e.company.isNotEmpty)
                  Text(e.company, style: TextStyle(fontSize: 12, color: accent, fontWeight: FontWeight.w500)),
                if (e.description.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(e.description, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                  ),
                if (e.highlights.isNotEmpty)
                  ...e.highlights.map((h) => Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text('\u2022 $h', style: TextStyle(fontSize: 11, color: accent)),
                  )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconItem(IconData icon, Widget content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: accent),
          ),
          const SizedBox(width: 8),
          Expanded(child: content),
        ],
      ),
    );
  }
}
