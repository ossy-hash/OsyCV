import 'package:flutter/material.dart';
import '../../../data/models/cv_data.dart';
import '../../../core/utils/helpers.dart';
import '../mixins/preview_section_renderers.dart';

class CreativePreview with PreviewSectionRenderers {
  final CVData cv;
  CreativePreview({required this.cv});

  Color get accent => Color(cv.primaryColor);

  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 130, child: _sidebar()),
        Expanded(child: _main()),
      ],
    );
  }

  Widget _sidebar() {
    final p = cv.personalInfo;
    final initials = p.fullName.isNotEmpty ? p.fullName[0].toUpperCase() : '?';
    return Container(
      padding: const EdgeInsets.all(12),
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [accent, accent.withValues(alpha: 0.8)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: CircleAvatar(
              radius: 24,
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              child: Text(initials, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ),
          const SizedBox(height: 8),
          Text(p.fullName, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
          if (p.jobTitle.isNotEmpty)
            Text(p.jobTitle, style: const TextStyle(fontSize: 11, color: Colors.white70)),
          const SizedBox(height: 10),
          if (p.email.isNotEmpty) Text(p.email, style: const TextStyle(fontSize: 10, color: Colors.white70)),
          if (p.phone.isNotEmpty) Text(p.phone, style: const TextStyle(fontSize: 10, color: Colors.white70)),
          if (p.linkedIn.isNotEmpty) Text(p.linkedIn, style: const TextStyle(fontSize: 10, color: Colors.white70)),
          if (p.github.isNotEmpty) Text(p.github, style: const TextStyle(fontSize: 10, color: Colors.white70)),
          if (p.portfolio.isNotEmpty) Text(p.portfolio, style: const TextStyle(fontSize: 10, color: Colors.white70)),
          if (p.address.isNotEmpty) Text(p.address, style: const TextStyle(fontSize: 10, color: Colors.white70)),
          if (cv.showSkills && cv.skills.where((s) => s.name.isNotEmpty).isNotEmpty) ...[
            const SizedBox(height: 10),
            const Text('SKILLS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.5)),
            const SizedBox(height: 6),
            ...cv.skills.where((s) => s.name.isNotEmpty).map((s) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(s.name, style: const TextStyle(fontSize: 10, color: Colors.white70)),
                  const SizedBox(height: 2),
                  Container(
                    width: 100,
                    height: 3,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),
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
                ],
              ),
            )),
          ],
          if (cv.showLanguages && cv.languages.where((l) => l.name.isNotEmpty).isNotEmpty) ...[
            const SizedBox(height: 10),
            const Text('LANGUAGES', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.5)),
            const SizedBox(height: 4),
            ...cv.languages.where((l) => l.name.isNotEmpty).map((l) => Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Text('${l.name} (${l.level})', style: const TextStyle(fontSize: 10, color: Colors.white)),
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
              _sectionTitle('About Me'),
              Text(cv.summary, style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
              const SizedBox(height: 12),
            ],
            if (cv.showExperience && cv.experiences.isNotEmpty) ...[
              _sectionTitle('Experience'),
              ...cv.experiences.map((e) => _timelineItem(e)),
            ],
            if (cv.showEducation && cv.educations.isNotEmpty) ...[
              _sectionTitle('Education'),
              ...cv.educations.map((e) => previewEducationItem(e)),
            ],
            if (cv.showProjects && cv.projects.isNotEmpty) ...[
              _sectionTitle('Projects'),
              ...cv.projects.map((p) => previewProjectItem(p, accent)),
            ],
            if (cv.showCertifications && cv.certifications.isNotEmpty) ...[
              _sectionTitle('Certifications'),
              ...cv.certifications.map((c) => Row(
                children: [
                  Icon(Icons.verified_outlined, size: 14, color: accent),
                  const SizedBox(width: 4),
                  Expanded(child: previewCertificationItem(c)),
                ],
              )),
            ],
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(title.toUpperCase(), style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: accent, letterSpacing: 1.5)),
    );
  }

  Widget _timelineItem(Experience e) {
    final dateStr = dateRangeString(e.startDate, e.endDate, current: e.current);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(width: 6, height: 6, decoration: BoxDecoration(color: accent, shape: BoxShape.circle)),
              Container(width: 1, height: 60, color: accent.withValues(alpha: 0.3)),
            ],
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(e.position, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    if (dateStr.isNotEmpty) Text(dateStr, style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
                  ],
                ),
                Text('${e.company}${e.company.isNotEmpty && dateStr.isNotEmpty ? ' | ' : ''}$dateStr', style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
                if (e.description.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(e.description, style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
                ],
                if (e.highlights.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  ...e.highlights.map((h) => Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Text('\u2022 $h', style: TextStyle(fontSize: 11, color: accent)),
                  )),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
