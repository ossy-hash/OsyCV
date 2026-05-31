import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../../data/models/cv_data.dart';
import '../../../core/utils/pdf_helpers.dart';
import '../../../core/utils/helpers.dart';
import '../../../core/constants/app_constants.dart';
import '../mixins/pdf_section_renderers.dart';

class TimelinePdfTemplate with PdfSectionRenderers {
  final CVData cv;
  TimelinePdfTemplate({required this.cv});

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
                  ...cv.educations.map((e) => _eduItem(e)),
                ],
                if (cv.showSkills && cv.skills.where((s) => s.name.isNotEmpty).isNotEmpty) ...[
                  _sectionTitle('Skills'),
                  ...cv.skills.where((s) => s.name.isNotEmpty).map((s) => _skillBar(s)),
                  pw.SizedBox(height: 8),
                ],
                if (cv.showLanguages && cv.languages.where((l) => l.name.isNotEmpty).isNotEmpty) ...[
                  _sectionTitle('Languages'),
                  pdfLanguageInline(cv.languages),
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
          ),
        ),
      ],
    );
  }

  pw.Widget _buildHeader() {
    final p = cv.personalInfo;
    return pw.Container(
      padding: const pw.EdgeInsets.fromLTRB(24, 24, 24, 12),
      decoration: pw.BoxDecoration(
        border: pw.Border(bottom: pw.BorderSide(color: primary, width: 3)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(p.fullName, style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold, letterSpacing: -0.5)),
          if (p.jobTitle.isNotEmpty)
            pw.Text(p.jobTitle, style: pw.TextStyle(fontSize: 11, color: primary)),
          pw.SizedBox(height: 6),
          pw.Wrap(
            spacing: 12,
            children: [
              if (p.email.isNotEmpty) _headerInfo(p.email),
              if (p.phone.isNotEmpty) _headerInfo(p.phone),
              if (p.linkedIn.isNotEmpty) _headerInfo(p.linkedIn),
              if (p.github.isNotEmpty) _headerInfo(p.github),
              if (p.address.isNotEmpty) _headerInfo(p.address),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _headerInfo(String text) {
    return pw.Text(text, style: pw.TextStyle(fontSize: 9, color: PdfColors.grey600));
  }

  pw.Widget _sectionTitle(String title) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(title.toUpperCase(), style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: primary, letterSpacing: 2)),
        pw.Divider(color: PdfColors.grey300, height: 12),
      ],
    );
  }

  pw.Widget _timelineItem(Experience e) {
    final dateStr = dateRangeString(e.startDate, e.endDate, current: e.current);
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(
          width: 55,
          child: pw.Text(dateStr, style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold, color: PdfColors.grey)),
        ),
        pw.Column(
          children: [
            pw.Container(width: 10, height: 10, decoration: pw.BoxDecoration(
              color: primary, shape: pw.BoxShape.circle,
              border: pw.Border.all(color: PdfColors.white, width: 2),
            )),
            pw.Container(width: 1, height: 60, color: lighten(primary, 0.6)),
          ],
        ),
        pw.SizedBox(width: 8),
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(e.position, style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
              if (e.company.isNotEmpty)
                pw.Text(e.company, style: pw.TextStyle(fontSize: 9, color: primary)),
              if (e.description.isNotEmpty) ...[
                pw.SizedBox(height: 4),
                pw.Text(e.description, style: pw.TextStyle(fontSize: 9, lineSpacing: 1.3)),
              ],
              if (e.highlights.isNotEmpty) ...[
                pw.SizedBox(height: 2),
                ...e.highlights.map((h) => pw.Text('- $h', style: pw.TextStyle(fontSize: 8, color: primary))),
              ],
              pw.SizedBox(height: 10),
            ],
          ),
        ),
      ],
    );
  }

  pw.Widget _eduItem(Education e) {
    final yearStr = _yearRange(e.startDate, e.endDate);
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(
          width: 55,
          child: pw.Text(yearStr, style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold, color: PdfColors.grey)),
        ),
        pw.Column(
          children: [
            pw.Container(width: 6, height: 6, decoration: pw.BoxDecoration(
              color: lighten(primary, 0.5), shape: pw.BoxShape.circle,
            )),
            pw.Container(width: 1, height: 20, color: lighten(primary, 0.6)),
          ],
        ),
        pw.SizedBox(width: 8),
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('${e.degree}${e.field.isNotEmpty ? ' in ${e.field}' : ''}',
                  style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
              pw.Text(
                '${e.institution}${e.gpa != null ? ' | GPA: ${e.gpa}' : ''}',
                style: pw.TextStyle(fontSize: 9, color: PdfColors.grey),
              ),
              pw.SizedBox(height: 8),
            ],
          ),
        ),
      ],
    );
  }

  String _yearRange(DateTime? from, DateTime? to) {
    if (from == null && to == null) return '';
    return '${from?.year ?? ''} - ${to?.year ?? 'Present'}';
  }

  pw.Widget _skillBar(Skill s) {
    final level = s.level.clamp(1, 5);
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 4),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(s.name, style: pw.TextStyle(fontSize: 9)),
              pw.Text(AppConstants.skillLevels[level - 1], style: pw.TextStyle(fontSize: 8, color: PdfColors.grey)),
            ],
          ),
          pw.SizedBox(height: 2),
          pw.Container(
            width: 200, height: 5,
            decoration: pw.BoxDecoration(
              color: PdfColors.grey300,
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(3)),
            ),
            child: pw.Container(
              width: 200 * (level / 5),
              height: 5,
              decoration: pw.BoxDecoration(
                color: primary,
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(3)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
