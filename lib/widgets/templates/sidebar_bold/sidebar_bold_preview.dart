import 'package:flutter/material.dart';
import '../../../data/models/cv_data.dart';
import '../mixins/preview_section_renderers.dart';

class SidebarBoldPreview with PreviewSectionRenderers {
  final CVData cv;
  SidebarBoldPreview({required this.cv});

  static const _darkNavy = Color(0xFF1A1A2E);
  Color get accent => Color(cv.primaryColor);

  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 150, child: _sidebar()),
        Expanded(child: _main()),
      ],
    );
  }

  String _getInitials() {
    final name = cv.personalInfo.fullName.trim();
    if (name.isEmpty) return '?';
    final parts = name.split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name[0].toUpperCase();
  }

  Widget _sidebar() {
    final p = cv.personalInfo;
    final initials = _getInitials();
    return Container(
      padding: const EdgeInsets.all(12),
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [accent, accent.withValues(alpha: 0.85), _darkNavy],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white.withValues(alpha: 0.15),
              child: Text(initials, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ),
          const SizedBox(height: 8),
          Text(p.fullName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
          if (p.jobTitle.isNotEmpty)
            Text(p.jobTitle, style: const TextStyle(fontSize: 10, color: Colors.white60)),
          const SizedBox(height: 10),
          if (p.email.isNotEmpty) _contactItem(Icons.email_outlined, p.email),
          if (p.phone.isNotEmpty) _contactItem(Icons.phone_outlined, p.phone),
          if (p.linkedIn.isNotEmpty) _contactItem(Icons.link, p.linkedIn),
          if (p.github.isNotEmpty) _contactItem(Icons.code, p.github),
          if (p.portfolio.isNotEmpty) _contactItem(Icons.language, p.portfolio),
          if (p.address.isNotEmpty) _contactItem(Icons.location_on_outlined, p.address),
          if (p.nationality.isNotEmpty) _contactItem(Icons.person_outline, p.nationality),
          if (cv.showSkills && cv.skills.where((s) => s.name.isNotEmpty).isNotEmpty) ...[
            const SizedBox(height: 12),
            const Text('SKILLS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.5)),
            const SizedBox(height: 6),
            ...cv.skills.where((s) => s.name.isNotEmpty).map((s) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  SizedBox(width: 70, child: Text(s.name, style: const TextStyle(fontSize: 9, color: Colors.white))),
                  Expanded(
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: s.level / 5,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text('${s.level}/5', style: const TextStyle(fontSize: 8, color: Colors.white38)),
                ],
              ),
            )),
          ],
          if (cv.showLanguages && cv.languages.where((l) => l.name.isNotEmpty).isNotEmpty) ...[
            const SizedBox(height: 12),
            const Text('LANGUAGES', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.5)),
            const SizedBox(height: 4),
            ...cv.languages.where((l) => l.name.isNotEmpty).map((l) => Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Text('${l.name} (${l.level})', style: const TextStyle(fontSize: 10, color: Colors.white70)),
            )),
          ],
        ],
      ),
    );
  }

  Widget _contactItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 12, color: Colors.white60),
          const SizedBox(width: 4),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 9, color: Colors.white70))),
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
              ...cv.experiences.map((e) => _leftBorderItem(previewExperienceItem(e, accent))),
            ],
            if (cv.showEducation && cv.educations.isNotEmpty) ...[
              _sectionHeader('Education'),
              ...cv.educations.map((e) => _leftBorderItem(previewEducationItem(e), width: 2, color: accent.withValues(alpha: 0.4))),
            ],
            if (cv.showProjects && cv.projects.isNotEmpty) ...[
              _sectionHeader('Projects'),
              ...cv.projects.map((p) => _leftBorderItem(previewProjectItem(p, accent), width: 2, color: accent.withValues(alpha: 0.4))),
            ],
            if (cv.showCertifications && cv.certifications.isNotEmpty) ...[
              _sectionHeader('Certifications'),
              ...cv.certifications.map((c) => _leftBorderItem(previewCertificationItem(c), width: 2, color: accent.withValues(alpha: 0.4))),
            ],
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Text(title.toUpperCase(), style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: accent, letterSpacing: 1.5)),
          const SizedBox(width: 8),
          Expanded(child: Container(height: 1, color: accent.withValues(alpha: 0.2))),
        ],
      ),
    );
  }

  Widget _leftBorderItem(Widget child, {double width = 3, Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: width, height: 40, color: color ?? accent),
          const SizedBox(width: 10),
          Expanded(child: child),
        ],
      ),
    );
  }
}
