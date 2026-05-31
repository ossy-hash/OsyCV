import 'dart:io';
import 'package:flutter/material.dart';
import '../../../data/models/cv_data.dart';
import '../mixins/preview_section_renderers.dart';

class ClassicPreview with PreviewSectionRenderers {
  final CVData cv;
  ClassicPreview({required this.cv});

  Color get accent => Color(cv.primaryColor);

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
      color: accent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (cv.showPhoto && p.photoPath.isNotEmpty && File(p.photoPath).existsSync())
            Center(
              child: ClipOval(
                child: Image.file(File(p.photoPath), width: 60, height: 60, fit: BoxFit.cover),
              ),
            ),
          if (cv.showPhoto && p.photoPath.isNotEmpty && File(p.photoPath).existsSync())
            const SizedBox(height: 8),
          Text(p.fullName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
          if (p.jobTitle.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(p.jobTitle, style: const TextStyle(fontSize: 12, color: Colors.white70)),
          ],
          const SizedBox(height: 12),
          if (p.email.isNotEmpty) Text(p.email, style: const TextStyle(fontSize: 10, color: Colors.white70)),
          if (p.phone.isNotEmpty) Text(p.phone, style: const TextStyle(fontSize: 10, color: Colors.white70)),
          if (p.linkedIn.isNotEmpty) Text(p.linkedIn, style: const TextStyle(fontSize: 10, color: Colors.white70)),
          if (p.github.isNotEmpty) Text(p.github, style: const TextStyle(fontSize: 10, color: Colors.white70)),
          if (p.portfolio.isNotEmpty) Text(p.portfolio, style: const TextStyle(fontSize: 10, color: Colors.white70)),
          if (p.address.isNotEmpty) Text(p.address, style: const TextStyle(fontSize: 10, color: Colors.white70)),
          if (p.nationality.isNotEmpty) Text(p.nationality, style: const TextStyle(fontSize: 10, color: Colors.white70)),
          if (cv.showSkills && cv.skills.where((s) => s.name.isNotEmpty).isNotEmpty) ...[
            const SizedBox(height: 12),
            const Text('SKILLS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.5)),
            const SizedBox(height: 4),
            ...cv.skills.where((s) => s.name.isNotEmpty).map((s) => Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Text(s.name, style: const TextStyle(fontSize: 11, color: Colors.white)),
            )),
          ],
          if (cv.showLanguages && cv.languages.where((l) => l.name.isNotEmpty).isNotEmpty) ...[
            const SizedBox(height: 12),
            const Text('LANGUAGES', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.5)),
            const SizedBox(height: 4),
            ...cv.languages.where((l) => l.name.isNotEmpty).map((l) => Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Text('${l.name} (${l.level})', style: const TextStyle(fontSize: 11, color: Colors.white)),
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
            previewSectionTitle('Professional Summary', accent),
            Text(cv.summary, style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
            const SizedBox(height: 12),
          ],
          if (cv.showExperience && cv.experiences.isNotEmpty) ...[
            previewSectionTitle('Experience', accent),
            previewSectionDivider(accent),
            ...cv.experiences.map((e) => previewExperienceItem(e, accent)),
          ],
          if (cv.showEducation && cv.educations.isNotEmpty) ...[
            previewSectionTitle('Education', accent),
            previewSectionDivider(accent),
            ...cv.educations.map((e) => previewEducationItem(e)),
          ],
          if (cv.showProjects && cv.projects.isNotEmpty) ...[
            previewSectionTitle('Projects', accent),
            previewSectionDivider(accent),
            ...cv.projects.map((p) => previewProjectItem(p, accent)),
          ],
          if (cv.showCertifications && cv.certifications.isNotEmpty) ...[
            previewSectionTitle('Certifications', accent),
            previewSectionDivider(accent),
            ...cv.certifications.map((c) => previewCertificationItem(c)),
          ],
        ],
      ),
      ),
    );
  }
}
