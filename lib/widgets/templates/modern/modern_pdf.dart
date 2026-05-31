import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../../data/models/cv_data.dart';
import '../../../core/utils/pdf_helpers.dart';
import '../mixins/pdf_section_renderers.dart';

class ModernPdfTemplate with PdfSectionRenderers {
  final CVData cv;
  ModernPdfTemplate({required this.cv});

  PdfColor get primary => PdfColor.fromInt(cv.primaryColor);

  pw.Widget build() {
    return pw.Column(
      children: [
        _header(),
        pw.Expanded(child: _body()),
      ],
    );
  }

  pw.Widget _header() {
    final p = cv.personalInfo;
    return pw.Container(
      padding: const pw.EdgeInsets.fromLTRB(24, 24, 24, 16),
      decoration: pw.BoxDecoration(
        gradient: pw.LinearGradient(
          begin: pw.Alignment.centerLeft,
          end: pw.Alignment.centerRight,
          colors: [primary, lighten(primary, 0.3)],
        ),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(p.fullName, style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColors.white)),
          if (p.jobTitle.isNotEmpty)
            pw.Padding(
              padding: const pw.EdgeInsets.only(top: 4, bottom: 8),
              child: pw.Text(p.jobTitle.toUpperCase(), style: pw.TextStyle(fontSize: 12, color: PdfColors.white, letterSpacing: 2)),
            ),
          pw.Wrap(
            spacing: 8,
            children: [
              if (p.email.isNotEmpty) pw.Text(p.email, style: pw.TextStyle(fontSize: 9, color: PdfColors.white)),
              if (p.email.isNotEmpty && p.phone.isNotEmpty) pw.Text(' | ', style: pw.TextStyle(fontSize: 9, color: PdfColors.white)),
              if (p.phone.isNotEmpty) pw.Text(p.phone, style: pw.TextStyle(fontSize: 9, color: PdfColors.white)),
              if (p.phone.isNotEmpty && (p.linkedIn.isNotEmpty || p.github.isNotEmpty)) pw.Text(' | ', style: pw.TextStyle(fontSize: 9, color: PdfColors.white)),
              if (p.linkedIn.isNotEmpty) pw.Text(p.linkedIn, style: pw.TextStyle(fontSize: 9, color: PdfColors.white)),
              if (p.linkedIn.isNotEmpty && p.github.isNotEmpty) pw.Text(' | ', style: pw.TextStyle(fontSize: 9, color: PdfColors.white)),
              if (p.github.isNotEmpty) pw.Text(p.github, style: pw.TextStyle(fontSize: 9, color: PdfColors.white)),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _body() {
    return pw.Container(
      padding: const pw.EdgeInsets.all(24),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          if (cv.showSummary && cv.summary.isNotEmpty) ...[
            _sectionHeader('Professional Summary'),
            pw.Text(cv.summary, style: pw.TextStyle(fontSize: 9, lineSpacing: 1.3)),
            pw.SizedBox(height: 12),
          ],
          if (cv.showExperience && cv.experiences.isNotEmpty) ...[
            _sectionHeader('Experience'),
            ...cv.experiences.map((e) => pdfExperienceItem(e, primary)),
          ],
          if (cv.showEducation && cv.educations.isNotEmpty) ...[
            _sectionHeader('Education'),
            ...cv.educations.map((e) => pdfEducationItem(e)),
          ],
          if (cv.showSkills && cv.skills.where((s) => s.name.isNotEmpty).isNotEmpty) ...[
            _sectionHeader('Skills'),
            pdfSkillChips(cv.skills, primary),
            pw.SizedBox(height: 12),
          ],
          if (cv.showLanguages && cv.languages.where((l) => l.name.isNotEmpty).isNotEmpty) ...[
            _sectionHeader('Languages'),
            pdfLanguageInline(cv.languages),
          ],
          if (cv.showProjects && cv.projects.isNotEmpty) ...[
            _sectionHeader('Projects'),
            ...cv.projects.map((p) => pdfProjectItem(p, primary)),
          ],
          if (cv.showCertifications && cv.certifications.isNotEmpty) ...[
            _sectionHeader('Certifications'),
            ...cv.certifications.map((c) => pdfCertificationItem(c)),
          ],
        ],
      ),
    );
  }

  pw.Widget _sectionHeader(String title) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(title.toUpperCase(), style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold, color: primary, letterSpacing: 1.2)),
        pw.Container(
          margin: const pw.EdgeInsets.only(top: 2, bottom: 8),
          width: 40,
          height: 2,
          color: primary,
        ),
      ],
    );
  }
}
