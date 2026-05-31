import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../../data/models/cv_data.dart';
import '../mixins/pdf_section_renderers.dart';

class MinimalPdfTemplate with PdfSectionRenderers {
  final CVData cv;
  MinimalPdfTemplate({required this.cv});

  pw.Widget build() {
    return pw.Container(
      padding: const pw.EdgeInsets.all(24),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _header(),
          if (cv.showSummary && cv.summary.isNotEmpty) ...[
            _sectionHeader('Professional Summary'),
            pw.Text(cv.summary, style: pw.TextStyle(fontSize: 9, lineSpacing: 1.3)),
            pw.SizedBox(height: 12),
          ],
          if (cv.showExperience && cv.experiences.isNotEmpty) ...[
            _sectionHeader('Experience'),
            ...cv.experiences.map((e) => pdfExperienceItem(e, PdfColors.grey, compact: true)),
          ],
          if (cv.showEducation && cv.educations.isNotEmpty) ...[
            _sectionHeader('Education'),
            ...cv.educations.map((e) => pdfEducationItem(e)),
          ],
          if (cv.showSkills && cv.skills.where((s) => s.name.isNotEmpty).isNotEmpty) ...[
            _sectionHeader('Skills'),
            pdfLanguageInline(cv.skills.map((s) => Language(name: s.name, level: '')).toList()),
          ],
          if (cv.showLanguages && cv.languages.where((l) => l.name.isNotEmpty).isNotEmpty) ...[
            _sectionHeader('Languages'),
            pdfLanguageInline(cv.languages),
          ],
          if (cv.showCertifications && cv.certifications.isNotEmpty) ...[
            _sectionHeader('Certifications'),
            ...cv.certifications.map((c) => pdfCertificationItem(c)),
          ],
        ],
      ),
    );
  }

  pw.Widget _header() {
    final p = cv.personalInfo;
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(p.fullName, style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold, letterSpacing: 4)),
        if (p.jobTitle.isNotEmpty)
          pw.Text(p.jobTitle.toUpperCase(), style: pw.TextStyle(fontSize: 10, color: PdfColors.grey, letterSpacing: 2)),
        pw.SizedBox(height: 4),
        pw.Wrap(
          spacing: 6,
          children: [
            if (p.email.isNotEmpty) pw.Text(p.email, style: pw.TextStyle(fontSize: 9, color: PdfColors.grey)),
            if (p.email.isNotEmpty && p.phone.isNotEmpty) pw.Text(' / ', style: pw.TextStyle(fontSize: 9, color: PdfColors.grey)),
            if (p.phone.isNotEmpty) pw.Text(p.phone, style: pw.TextStyle(fontSize: 9, color: PdfColors.grey)),
            if (p.phone.isNotEmpty && (p.linkedIn.isNotEmpty || p.github.isNotEmpty)) pw.Text(' / ', style: pw.TextStyle(fontSize: 9, color: PdfColors.grey)),
            if (p.linkedIn.isNotEmpty) pw.Text(p.linkedIn, style: pw.TextStyle(fontSize: 9, color: PdfColors.grey)),
            if (p.linkedIn.isNotEmpty && p.github.isNotEmpty) pw.Text(' / ', style: pw.TextStyle(fontSize: 9, color: PdfColors.grey)),
            if (p.github.isNotEmpty) pw.Text(p.github, style: pw.TextStyle(fontSize: 9, color: PdfColors.grey)),
          ],
        ),
        _divider(),
      ],
    );
  }

  pw.Widget _sectionHeader(String title) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(title.toUpperCase(), style: pw.TextStyle(fontSize: 9, color: PdfColors.grey, letterSpacing: 3)),
        _divider(),
      ],
    );
  }

  pw.Widget _divider() {
    return pw.Container(
      height: 0.5,
      margin: const pw.EdgeInsets.symmetric(vertical: 8),
      color: PdfColors.grey300,
    );
  }
}
