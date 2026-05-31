import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../../data/models/cv_data.dart';
import '../../../core/utils/pdf_helpers.dart';
import '../mixins/pdf_section_renderers.dart';

class MaterialPdfTemplate with PdfSectionRenderers {
  final CVData cv;
  MaterialPdfTemplate({required this.cv});

  PdfColor get primary => PdfColor.fromInt(cv.primaryColor);

  pw.Widget build() {
    return pw.Column(
      children: [
        _buildHeader(),
        pw.Expanded(
          child: pw.Container(
            padding: const pw.EdgeInsets.all(16),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                if (cv.showSummary && cv.summary.isNotEmpty) ...[
                  _sectionTitle('Professional Summary'),
                  pw.Text(cv.summary, style: pw.TextStyle(fontSize: 9, lineSpacing: 1.3)),
                  pw.SizedBox(height: 12),
                ],
                if (cv.showExperience && cv.experiences.isNotEmpty) ...[
                  _sectionTitle('Experience'),
                  ...cv.experiences.map((e) => _timelineItem(e)),
                ],
                if (cv.showEducation && cv.educations.isNotEmpty) ...[
                  _sectionTitle('Education'),
                  ...cv.educations.map((e) => _badgeItem(e.institution.isNotEmpty ? 'E' : '', pdfEducationItem(e))),
                ],
                if (cv.showSkills && cv.skills.where((s) => s.name.isNotEmpty).isNotEmpty) ...[
                  _sectionTitle('Skills'),
                  pdfSkillChips(cv.skills, primary),
                  pw.SizedBox(height: 12),
                ],
                if (cv.showLanguages && cv.languages.where((l) => l.name.isNotEmpty).isNotEmpty) ...[
                  _sectionTitle('Languages'),
                  pdfLanguageInline(cv.languages),
                ],
                if (cv.showProjects && cv.projects.isNotEmpty) ...[
                  _sectionTitle('Projects'),
                  ...cv.projects.map((p) => _badgeItem('P', pdfProjectItem(p, primary))),
                ],
                if (cv.showCertifications && cv.certifications.isNotEmpty) ...[
                  _sectionTitle('Certifications'),
                  ...cv.certifications.map((c) => _badgeItem('C', pdfCertificationItem(c))),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  pw.Widget _buildHeader() {
    final p = cv.personalInfo;
    final initials = p.fullName.isNotEmpty ? p.fullName[0].toUpperCase() : '?';
    return pw.Container(
      padding: const pw.EdgeInsets.fromLTRB(24, 24, 24, 16),
      decoration: pw.BoxDecoration(
        gradient: pw.LinearGradient(
          begin: pw.Alignment.centerLeft,
          end: pw.Alignment.centerRight,
          colors: [primary, darken(primary, 0.3)],
        ),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            children: [
              pw.ClipOval(
                child: pw.Container(
                  width: 56, height: 56,
                  color: lighten(primary, 0.3),
                  child: pw.Center(
                    child: pw.Text(initials, style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold, color: PdfColors.white)),
                  ),
                ),
              ),
              pw.SizedBox(width: 16),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(p.fullName, style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold, color: PdfColors.white)),
                  if (p.jobTitle.isNotEmpty)
                    pw.Text(p.jobTitle, style: pw.TextStyle(fontSize: 11, color: PdfColors.white)),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 8),
          pw.Wrap(
            spacing: 8,
            children: [
              if (p.email.isNotEmpty) _headerInfo(p.email),
              if (p.phone.isNotEmpty) _headerInfo(p.phone),
              if (p.linkedIn.isNotEmpty) _headerInfo(p.linkedIn),
              if (p.github.isNotEmpty) _headerInfo(p.github),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _headerInfo(String text) {
    return pw.Text(text, style: pw.TextStyle(fontSize: 9, color: PdfColors.white));
  }

  pw.Widget _sectionTitle(String title) {
    return pw.Row(
      children: [
        pw.Container(width: 4, height: 16, decoration: pw.BoxDecoration(
          color: primary, borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)),
        )),
        pw.SizedBox(width: 8),
        pw.Text(title, style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: primary)),
        pw.SizedBox(height: 12),
      ],
    );
  }

  pw.Widget _timelineItem(Experience e) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Column(
          children: [
            pw.Container(width: 8, height: 8, decoration: pw.BoxDecoration(color: primary, shape: pw.BoxShape.circle)),
            pw.Container(width: 1, height: 50, color: lighten(primary, 0.5)),
          ],
        ),
        pw.SizedBox(width: 8),
        pw.Expanded(child: pdfExperienceItem(e, primary)),
      ],
    );
  }

  pw.Widget _badgeItem(String badge, pw.Widget content) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Container(
          width: 20, height: 20,
          decoration: pw.BoxDecoration(
            color: lighten(primary, 0.5),
            borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
          ),
          child: pw.Center(child: pw.Text(badge, style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: primary))),
        ),
        pw.SizedBox(width: 8),
        pw.Expanded(child: content),
      ],
    );
  }
}
