import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../../data/models/cv_data.dart';
import '../mixins/pdf_section_renderers.dart';

class ClassicPdfTemplate with PdfSectionRenderers {
  final CVData cv;
  ClassicPdfTemplate({required this.cv});

  PdfColor get primary => PdfColor.fromInt(cv.primaryColor);

  pw.Widget build() {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(width: 180, child: _sidebar()),
        pw.Expanded(child: _main()),
      ],
    );
  }

  pw.Widget _sidebar() {
    final p = cv.personalInfo;
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      color: primary,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(p.fullName, style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: PdfColors.white)),
          if (p.jobTitle.isNotEmpty)
            pw.Padding(
              padding: const pw.EdgeInsets.only(top: 2, bottom: 12),
              child: pw.Text(p.jobTitle, style: pw.TextStyle(fontSize: 10, color: PdfColors.white)),
            ),
          pdfContactItem('Email', p.email),
          pdfContactItem('Phone', p.phone),
          pdfContactItem('LinkedIn', p.linkedIn),
          pdfContactItem('GitHub', p.github),
          pdfContactItem('Portfolio', p.portfolio),
          pdfContactItem('Address', p.address),
          pdfContactItem('Nationality', p.nationality),
          if (cv.showSkills && cv.skills.where((s) => s.name.isNotEmpty).isNotEmpty) ...[
            pw.SizedBox(height: 12),
            pdfSidebarSectionTitle('Skills'),
            ...cv.skills.where((s) => s.name.isNotEmpty).map((s) => pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 2),
              child: pw.Text(s.name, style: pw.TextStyle(fontSize: 9, color: PdfColors.white)),
            )),
          ],
          if (cv.showLanguages && cv.languages.where((l) => l.name.isNotEmpty).isNotEmpty) ...[
            pw.SizedBox(height: 12),
            pdfSidebarSectionTitle('Languages'),
            ...cv.languages.where((l) => l.name.isNotEmpty).map((l) => pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 2),
              child: pw.Text('${l.name} (${l.level})', style: pw.TextStyle(fontSize: 9, color: PdfColors.white)),
            )),
          ],
        ],
      ),
    );
  }

  pw.Widget _main() {
    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          if (cv.showSummary && cv.summary.isNotEmpty) ...[
            pdfSectionTitle('PROFESSIONAL SUMMARY', primary),
            pw.Text(cv.summary, style: pw.TextStyle(fontSize: 9, lineSpacing: 1.3)),
            pw.SizedBox(height: 12),
          ],
          if (cv.showExperience && cv.experiences.isNotEmpty) ...[
            pdfSectionTitle('EXPERIENCE', primary),
            pdfSectionDivider(primary),
            ...cv.experiences.map((e) => pdfExperienceItem(e, primary)),
          ],
          if (cv.showEducation && cv.educations.isNotEmpty) ...[
            pdfSectionTitle('EDUCATION', primary),
            pdfSectionDivider(primary),
            ...cv.educations.map((e) => pdfEducationItem(e)),
          ],
          if (cv.showProjects && cv.projects.isNotEmpty) ...[
            pdfSectionTitle('PROJECTS', primary),
            pdfSectionDivider(primary),
            ...cv.projects.map((p) => pdfProjectItem(p, primary)),
          ],
          if (cv.showCertifications && cv.certifications.isNotEmpty) ...[
            pdfSectionTitle('CERTIFICATIONS', primary),
            pdfSectionDivider(primary),
            ...cv.certifications.map((c) => pdfCertificationItem(c)),
          ],
        ],
      ),
    );
  }
}
