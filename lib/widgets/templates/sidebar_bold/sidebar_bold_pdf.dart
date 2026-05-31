import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../../data/models/cv_data.dart';
import '../../../core/utils/pdf_helpers.dart';
import '../mixins/pdf_section_renderers.dart';

class SidebarBoldPdfTemplate with PdfSectionRenderers {
  final CVData cv;
  SidebarBoldPdfTemplate({required this.cv});

  static const _darkNavy = PdfColor.fromInt(0xFF1A1A2E);
  PdfColor get primary => PdfColor.fromInt(cv.primaryColor);

  pw.Widget build() {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(width: 170, child: _sidebar()),
        pw.Expanded(child: _main()),
      ],
    );
  }

  String _getInitials() {
    final name = cv.personalInfo.fullName.trim();
    if (name.isEmpty) return '?';
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }

  pw.Widget _sidebar() {
    final p = cv.personalInfo;
    final initials = _getInitials();
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        gradient: pw.LinearGradient(
          begin: pw.Alignment.topCenter,
          end: pw.Alignment.bottomCenter,
          colors: [primary, darken(primary, 0.2), _darkNavy],
        ),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Center(
            child: pw.ClipOval(
              child: pw.Container(
                width: 60, height: 60,
                color: lighten(primary, 0.3),
                child: pw.Center(
                  child: pw.Text(initials, style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold, color: PdfColors.white)),
                ),
              ),
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Text(p.fullName, style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: PdfColors.white)),
          if (p.jobTitle.isNotEmpty)
            pw.Text(p.jobTitle, style: pw.TextStyle(fontSize: 9, color: PdfColors.white)),
          pw.SizedBox(height: 10),
          _contactItem('Email', p.email),
          _contactItem('Phone', p.phone),
          _contactItem('LinkedIn', p.linkedIn),
          _contactItem('GitHub', p.github),
          _contactItem('Portfolio', p.portfolio),
          _contactItem('Address', p.address),
          _contactItem('Nationality', p.nationality),
          if (cv.showSkills && cv.skills.where((s) => s.name.isNotEmpty).isNotEmpty) ...[
            pw.SizedBox(height: 12),
            pdfSidebarSectionTitle('Skills'),
            ...cv.skills.where((s) => s.name.isNotEmpty).map((s) => pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 4),
              child: pw.Row(
                children: [
                  pw.SizedBox(width: 80, child: pw.Text(s.name, style: pw.TextStyle(fontSize: 8, color: PdfColors.white))),
                  pw.SizedBox(
                    width: 60,
                    height: 4,
                    child: pw.Stack(
                      children: [
                        pw.Container(height: 4, decoration: pw.BoxDecoration(
                          color: whiteWithOpacity(0.3),
                          borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)),
                        )),
                        pw.Container(
                          width: 60 * (s.level / 5),
                          height: 4,
                          decoration: pw.BoxDecoration(
                            color: PdfColors.white,
                            borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  pw.SizedBox(width: 4),
                  pw.Text('${s.level}/5', style: pw.TextStyle(fontSize: 7, color: whiteWithOpacity(0.38))),
                ],
              ),
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

  pw.Widget _contactItem(String label, String value) {
    if (value.isEmpty) return pw.SizedBox();
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 2),
      child: pw.Text('$label: $value', style: pw.TextStyle(fontSize: 8, color: PdfColors.white)),
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
            ...cv.experiences.map((e) => _leftBorderItem(pdfExperienceItem(e, primary))),
          ],
          if (cv.showEducation && cv.educations.isNotEmpty) ...[
            _sectionHeader('Education'),
            ...cv.educations.map((e) => _leftBorderItem(pdfEducationItem(e), width: 2, color: lighten(primary, 0.5))),
          ],
          if (cv.showProjects && cv.projects.isNotEmpty) ...[
            _sectionHeader('Projects'),
            ...cv.projects.map((p) => _leftBorderItem(pdfProjectItem(p, primary), width: 2, color: lighten(primary, 0.5))),
          ],
          if (cv.showCertifications && cv.certifications.isNotEmpty) ...[
            _sectionHeader('Certifications'),
            ...cv.certifications.map((c) => _leftBorderItem(pdfCertificationItem(c), width: 2, color: lighten(primary, 0.5))),
          ],
        ],
      ),
    );
  }

  pw.Widget _sectionHeader(String title) {
    return pw.Row(
      children: [
        pw.Text(title.toUpperCase(), style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold, color: primary, letterSpacing: 1.5)),
        pw.SizedBox(width: 8),
        pw.Expanded(child: pw.Container(height: 1, color: lighten(primary, 0.6))),
        pw.SizedBox(height: 14),
      ],
    );
  }

  pw.Widget _leftBorderItem(pw.Widget child, {double width = 3, PdfColor? color}) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Container(width: width, height: 50, color: color ?? primary),
        pw.SizedBox(width: 10),
        pw.Expanded(child: child),
      ],
    );
  }
}
