import 'package:flutter/material.dart';
import '../../../core/utils/helpers.dart';
import '../../../data/models/cv_data.dart';

mixin PreviewSectionRenderers {
  Widget previewSectionTitle(String title, Color color, {double fontSize = 15}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: color,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget previewSectionDivider(Color color) {
    return Container(
      height: 1,
      margin: const EdgeInsets.only(bottom: 8),
      color: color.withValues(alpha: 0.3),
    );
  }

  Widget previewExperienceItem(Experience e, Color accent, {Color? bulletColor}) {
    final dateStr = dateRangeString(e.startDate, e.endDate, current: e.current);
    final bulletCol = bulletColor ?? accent;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(e.position, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              ),
              if (dateStr.isNotEmpty)
                Text(dateStr, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
            ],
          ),
          if (e.company.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 1),
              child: Text(e.company, style: TextStyle(fontSize: 11, color: accent, fontWeight: FontWeight.w500)),
            ),
          if (e.description.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(e.description, style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
          ],
          if (e.highlights.isNotEmpty) ...[
            const SizedBox(height: 4),
            ...e.highlights.map((h) => Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text('\u2022 $h', style: TextStyle(fontSize: 11, color: bulletCol)),
                )),
          ],
        ],
      ),
    );
  }

  Widget previewEducationItem(Education e) {
    final dateStr = dateRangeString(e.startDate, e.endDate);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '${e.degree}${e.field.isNotEmpty ? ' in ${e.field}' : ''}',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ),
              if (dateStr.isNotEmpty)
                Text(dateStr, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
            ],
          ),
          if (e.institution.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 1),
              child: Row(
                children: [
                  Text(e.institution, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                  if (e.gpa != null) ...[
                    const SizedBox(width: 8),
                    Text('GPA: ${e.gpa}', style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget previewProjectItem(Project p, Color accent) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(p.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          if (p.techStack.isNotEmpty)
            Text(p.techStack, style: TextStyle(fontSize: 11, color: accent, fontWeight: FontWeight.w500)),
          if (p.description.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(p.description, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
            ),
        ],
      ),
    );
  }

  Widget previewCertificationItem(Certification c) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(c.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          ),
          if (c.issuer.isNotEmpty || c.date != null)
            Text(
              '${c.issuer}${c.issuer.isNotEmpty && c.date != null ? ' - ' : ''}${c.date != null ? c.date!.year.toString() : ''}',
              style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
            ),
        ],
      ),
    );
  }

  Widget previewSkillChips(List<Skill> skills, Color accent) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: skills
          .where((s) => s.name.isNotEmpty)
          .map((s) => Chip(
                label: Text(s.name, style: TextStyle(fontSize: 11, color: accent)),
                backgroundColor: accent.withValues(alpha: 0.08),
                side: BorderSide(color: accent.withValues(alpha: 0.2)),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
                padding: const EdgeInsets.symmetric(horizontal: 4),
              ))
          .toList(),
    );
  }

  Widget previewLanguageInline(List<Language> languages) {
    final items = languages
        .where((l) => l.name.isNotEmpty)
        .map((l) => '${l.name}${l.level.isNotEmpty ? ' (${l.level})' : ''}')
        .join('  \u2022  ');
    if (items.isEmpty) return const SizedBox();
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(items, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
    );
  }

  Widget previewLanguageChips(List<Language> languages, Color accent) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: languages
          .where((l) => l.name.isNotEmpty)
          .map((l) => Chip(
                label: Text('${l.name}${l.level.isNotEmpty ? ' (${l.level})' : ''}',
                    style: TextStyle(fontSize: 11, color: accent)),
                backgroundColor: accent.withValues(alpha: 0.08),
                side: BorderSide(color: accent.withValues(alpha: 0.2)),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
                padding: const EdgeInsets.symmetric(horizontal: 4),
              ))
          .toList(),
    );
  }
}
