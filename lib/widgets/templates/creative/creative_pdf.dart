import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../../data/models/cv_data.dart';
import '../../../core/utils/pdf_helpers.dart';
import '../../../core/utils/helpers.dart';
import '../mixins/pdf_section_renderers.dart';

class CreativePdfTemplate with PdfSectionRenderers {
  final CVData cv;
  CreativePdfTemplate({required this.cv});

  PdfColor get primary => PdfColor.fromInt(cv.primaryColor);

  pw.Widget build() {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(width: 160, child: _sidebar()),
        pw.Expanded(child: _main()),
      ],
    );
  }

  pw.Widget _sidebar() {
    final p = cv.personalInfo;
    final initials = p.fullName.isNotEmpty ? p.fullName[0].toUpperCase() : '?';
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        gradient: pw.LinearGradient(
          begin: pw.Alignment.topCenter,
          end: pw.Alignment.bottomCenter,
          colors: [primary, darken(primary, 0.3)],
        ),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Center(
            child: pw.ClipOval(
              child: pw.Container(
                width: 60,
                height: 60,
                color: lighten(primary, 0.3),
                child: pw.Center(
                  child: pw.Text(initials, style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColors.white)),
                ),
              ),
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Text(p.fullName, style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColors.white)),
          if (p.jobTitle.isNotEmpty)
            pw.Text(p.jobTitle, style: pw.TextStyle(fontSize: 9, color: PdfColors.white)),
          pw.SizedBox(height: 10),
          pdfContactItem('Email', p.email),
          pdfContactItem('Phone', p.phone),
          pdfContactItem('LinkedIn', p.linkedIn),
          pdfContactItem('GitHub', p.github),
          pdfContactItem('Portfolio', p.portfolio),
          pdfContactItem('Address', p.address),
          if (cv.showSkills && cv.skills.where((s) => s.name.isNotEmpty).isNotEmpty) ...[
            pw.SizedBox(height: 10),
            pdfSidebarSectionTitle('Skills'),
            ...cv.skills.where((s) => s.name.isNotEmpty).map((s) => pdfSkillProgressBar(s, primary)),
          ],
          if (cv.showLanguages && cv.languages.where((l) => l.name.isNotEmpty).isNotEmpty) ...[
            pw.SizedBox(height: 10),
            pdfSidebarSectionTitle('Languages'),
            ...cv.languages.where((l) => l.name.isNotEmpty).map((l) => pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 2),
              child: pw.Text('${l.name} (${l.level})', style: pw.TextStyle(fontSize: 8, color: PdfColors.white)),
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
            _sectionTitle('About Me'),
            pw.Text(cv.summary, style: pw.TextStyle(fontSize: 9, lineSpacing: 1.3)),
            pw.SizedBox(height: 12),
          ],
          if (cv.showExperience && cv.experiences.isNotEmpty) ...[
            _sectionTitle('Experience'),
            ...cv.experiences.map((e) => _timelineItem(e)),
          ],
          if (cv.showEducation && cv.educations.isNotEmpty) ...[
            _sectionTitle('Education'),
            ...cv.educations.map((e) => pdfEducationItem(e)),
          ],
          if (cv.showProjects && cv.projects.isNotEmpty) ...[
            _sectionTitle('Projects'),
            ...cv.projects.map((p) => pdfProjectItem(p, primary)),
          ],
          if (cv.showCertifications && cv.certifications.isNotEmpty) ...[
            _sectionTitle('Certifications'),
            ...cv.certifications.map((c) => pdfCertificationItem(c)),
          ],
        ],
      ),
    );
  }

  pw.Widget _sectionTitle(String title) {
    return pw.Text(title.toUpperCase(), style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: primary, letterSpacing: 2));
  }

  pw.Widget _timelineItem(Experience e) {
    final dateStr = dateRangeString(e.startDate, e.endDate, current: e.current);
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Column(
          children: [
            pw.Container(width: 8, height: 8, decoration: pw.BoxDecoration(
              color: primary, shape: pw.BoxShape.circle,
            )),
            pw.Container(width: 1, height: 60, color: lighten(primary, 0.6)),
          ],
        ),
        pw.SizedBox(width: 8),
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(e.position, style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                  if (dateStr.isNotEmpty) pw.Text(dateStr, style: pw.TextStyle(fontSize: 8, color: PdfColors.grey)),
                ],
              ),
              pw.Text('${e.company}${e.company.isNotEmpty && dateStr.isNotEmpty ? ' | ' : ''}$dateStr', style: pw.TextStyle(fontSize: 8, color: PdfColors.grey)),
              if (e.description.isNotEmpty) ...[
                pw.SizedBox(height: 2),
                pw.Text(e.description, style: pw.TextStyle(fontSize: 9)),
              ],
              if (e.highlights.isNotEmpty) ...[
                pw.SizedBox(height: 2),
                ...e.highlights.map((h) => pw.Text('- $h', style: pw.TextStyle(fontSize: 8, color: primary))),
              ],
              pw.SizedBox(height: 8),
            ],
          ),
        ),
      ],
    );
  }
}
