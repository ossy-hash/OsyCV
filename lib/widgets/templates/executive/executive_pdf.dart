import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../../data/models/cv_data.dart';
import '../../../core/utils/pdf_helpers.dart';
import '../mixins/pdf_section_renderers.dart';

class ExecutivePdfTemplate with PdfSectionRenderers {
  final CVData cv;
  ExecutivePdfTemplate({required this.cv});

  static const _navy = PdfColor.fromInt(0xFF1A1A2E);
  static const _gold = PdfColor.fromInt(0xFFC8A951);

  pw.Widget build() {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(width: 170, child: _sidebar()),
        pw.Expanded(child: _main()),
      ],
    );
  }

  pw.Widget _sidebar() {
    final p = cv.personalInfo;
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      color: _navy,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(p.fullName, style: pw.TextStyle(fontSize: 15, fontWeight: pw.FontWeight.bold, color: _gold)),
          if (p.jobTitle.isNotEmpty)
            pw.Padding(
              padding: const pw.EdgeInsets.only(top: 2, bottom: 12),
              child: pw.Text(p.jobTitle, style: pw.TextStyle(fontSize: 9, color: PdfColors.white)),
            ),
          pdfContactItem('Email', p.email),
          pdfContactItem('Phone', p.phone),
          pdfContactItem('LinkedIn', p.linkedIn),
          pdfContactItem('GitHub', p.github),
          pdfContactItem('Portfolio', p.portfolio),
          pdfContactItem('Address', p.address),
          if (cv.showSkills && cv.skills.where((s) => s.name.isNotEmpty && s.level >= 4).isNotEmpty) ...[
            pw.SizedBox(height: 12),
            _sideTitle('Core Skills'),
            ...cv.skills.where((s) => s.name.isNotEmpty && s.level >= 4).map((s) => pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 2),
              child: pw.Text(s.name, style: pw.TextStyle(fontSize: 8, color: PdfColors.white)),
            )),
          ],
          if (cv.showLanguages && cv.languages.where((l) => l.name.isNotEmpty).isNotEmpty) ...[
            pw.SizedBox(height: 12),
            _sideTitle('Languages'),
            ...cv.languages.where((l) => l.name.isNotEmpty).map((l) => pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 2),
              child: pw.Text('${l.name} (${l.level})', style: pw.TextStyle(fontSize: 8, color: PdfColors.white)),
            )),
          ],
          if (cv.showCertifications && cv.certifications.isNotEmpty) ...[
            pw.SizedBox(height: 12),
            _sideTitle('Certifications'),
            ...cv.certifications.map((c) => pw.Text(c.name, style: pw.TextStyle(fontSize: 8, color: PdfColors.white))),
          ],
        ],
      ),
    );
  }

  pw.Widget _sideTitle(String title) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(title.toUpperCase(), style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold, color: _gold, letterSpacing: 2)),
        pw.Container(height: 0.5, margin: const pw.EdgeInsets.only(bottom: 4), color: lighten(_gold, 0.3)),
      ],
    );
  }

  pw.Widget _main() {
    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
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
            ...cv.experiences.map((e) => pdfExperienceItem(e, _navy)),
          ],
          if (cv.showEducation && cv.educations.isNotEmpty) ...[
            _sectionHeader('Education'),
            ...cv.educations.map((e) => pdfEducationItem(e)),
          ],
          if (cv.showProjects && cv.projects.isNotEmpty) ...[
            _sectionHeader('Projects'),
            ...cv.projects.map((p) => pdfProjectItem(p, _navy)),
          ],
        ],
      ),
    );
  }

  pw.Widget _sectionHeader(String title) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(title.toUpperCase(), style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: _navy, letterSpacing: 1.5)),
        pw.Container(margin: const pw.EdgeInsets.only(top: 2, bottom: 8), width: 50, height: 1.5, color: _gold),
      ],
    );
  }
}
