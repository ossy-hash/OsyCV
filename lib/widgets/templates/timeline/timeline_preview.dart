import 'package:flutter/material.dart';
import '../../../data/models/cv_data.dart';
import '../../../core/utils/helpers.dart';
import '../../../core/constants/app_constants.dart';
import '../mixins/preview_section_renderers.dart';

class TimelinePreview with PreviewSectionRenderers {
  final CVData cv;
  TimelinePreview({required this.cv});

  Color get accent => Color(cv.primaryColor);

  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          if (cv.showSummary && cv.summary.isNotEmpty) ...[
            _sectionTitle('Professional Summary'),
            Text(cv.summary, style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
            const SizedBox(height: 12),
          ],
          if (cv.showExperience && cv.experiences.isNotEmpty) ...[
            _sectionTitle('Experience'),
            ...cv.experiences.map((e) => _timelineItem(e)),
          ],
          if (cv.showEducation && cv.educations.isNotEmpty) ...[
            _sectionTitle('Education'),
            ...cv.educations.map((e) => _eduItem(e)),
          ],
          if (cv.showSkills && cv.skills.where((s) => s.name.isNotEmpty).isNotEmpty) ...[
            _sectionTitle('Skills'),
            ...cv.skills.where((s) => s.name.isNotEmpty).map((s) => _skillBar(s)),
            const SizedBox(height: 8),
          ],
          if (cv.showLanguages && cv.languages.where((l) => l.name.isNotEmpty).isNotEmpty) ...[
            _sectionTitle('Languages'),
            previewLanguageInline(cv.languages),
          ],
          if (cv.showProjects && cv.projects.isNotEmpty) ...[
            _sectionTitle('Projects'),
            ...cv.projects.map((p) => _projectItem(p)),
          ],
          if (cv.showCertifications && cv.certifications.isNotEmpty) ...[
            _sectionTitle('Certifications'),
            ...cv.certifications.map((c) => _certItem(c)),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final p = cv.personalInfo;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(p.fullName, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: -0.5)),
        if (p.jobTitle.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(p.jobTitle, style: TextStyle(fontSize: 13, color: accent, fontWeight: FontWeight.w500)),
          ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 16,
          runSpacing: 4,
          children: [
            if (p.email.isNotEmpty) _headerChip(Icons.email_outlined, p.email),
            if (p.phone.isNotEmpty) _headerChip(Icons.phone_outlined, p.phone),
            if (p.linkedIn.isNotEmpty) _headerChip(Icons.link, p.linkedIn),
            if (p.github.isNotEmpty) _headerChip(Icons.code, p.github),
            if (p.address.isNotEmpty) _headerChip(Icons.location_on_outlined, p.address),
          ],
        ),
        const SizedBox(height: 8),
        Container(width: 50, height: 3, decoration: BoxDecoration(
          color: accent, borderRadius: BorderRadius.circular(2),
        )),
      ],
    );
  }

  Widget _headerChip(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.grey.shade600),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(title.toUpperCase(), style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: accent, letterSpacing: 2)),
    );
  }

  Widget _timelineItem(Experience e) {
    final dateStr = dateRangeString(e.startDate, e.endDate, current: e.current);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 60,
            child: Text(dateStr, style: TextStyle(fontSize: 9, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
          ),
          Column(
            children: [
              Container(width: 12, height: 12, decoration: BoxDecoration(
                color: accent, shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              )),
              Container(width: 1, height: 40, color: accent.withValues(alpha: 0.2)),
            ],
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(e.position, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                if (e.company.isNotEmpty)
                  Text(e.company, style: TextStyle(fontSize: 11, color: accent, fontWeight: FontWeight.w500)),
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

  Widget _eduItem(Education e) {
    final yearStr = _yearRange(e.startDate, e.endDate);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 60,
            child: Text(yearStr, style: TextStyle(fontSize: 9, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
          ),
          Column(
            children: [
              Container(width: 8, height: 8, decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.5), shape: BoxShape.circle,
              )),
              Container(width: 1, height: 20, color: accent.withValues(alpha: 0.2)),
            ],
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${e.degree}${e.field.isNotEmpty ? ' in ${e.field}' : ''}',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                Text('${e.institution}${e.gpa != null ? ' | GPA: ${e.gpa}' : ''}',
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _yearRange(DateTime? from, DateTime? to) {
    if (from == null && to == null) return '';
    return '${from?.year ?? ''} - ${to?.year ?? 'Present'}';
  }

  Widget _skillBar(Skill s) {
    final level = s.level.clamp(1, 5);
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(s.name, style: const TextStyle(fontSize: 12)),
              Text(AppConstants.skillLevels[level - 1], style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
            ],
          ),
          const SizedBox(height: 2),
          Container(
            width: 200, height: 6,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(3),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: level / 5,
              child: Container(
                decoration: BoxDecoration(
                  color: accent,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _projectItem(Project p) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.folder_outlined, size: 16, color: accent),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p.name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                if (p.techStack.isNotEmpty)
                  Text(p.techStack, style: TextStyle(fontSize: 11, color: accent, fontWeight: FontWeight.w500)),
                if (p.description.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(p.description, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _certItem(Certification c) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(Icons.verified_outlined, size: 16, color: accent),
          const SizedBox(width: 8),
          Expanded(
            child: Row(
              children: [
                Text(c.name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                if (c.issuer.isNotEmpty || c.date != null) ...[
                  const SizedBox(width: 4),
                  Text(
                    '${c.issuer}${c.issuer.isNotEmpty && c.date != null ? ' - ' : ''}${c.date != null ? c.date!.year.toString() : ''}',
                    style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
