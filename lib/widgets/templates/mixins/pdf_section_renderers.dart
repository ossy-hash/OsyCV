import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../../core/utils/helpers.dart';
import '../../../core/utils/pdf_helpers.dart';
import '../../../data/models/cv_data.dart';

mixin PdfSectionRenderers {
  pw.Widget pdfSectionTitle(String title, PdfColor color, {double fontSize = 10}) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 6),
      child: pw.Text(
        title,
        style: pw.TextStyle(
          fontSize: fontSize,
          fontWeight: pw.FontWeight.bold,
          color: color,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  pw.Widget pdfSectionDivider(PdfColor color) {
    return pw.Container(
      height: 1,
      margin: const pw.EdgeInsets.only(bottom: 6),
      color: color,
    );
  }

  pw.Widget pdfExperienceItem(Experience e, PdfColor primary, {bool compact = false}) {
    final dateStr = dateRangeString(e.startDate, e.endDate, current: e.current);
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Expanded(
              child: pw.Text(
                e.position,
                style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
              ),
            ),
            if (dateStr.isNotEmpty)
              pw.Text(dateStr, style: pw.TextStyle(fontSize: 8, color: PdfColors.grey)),
          ],
        ),
        if (e.company.isNotEmpty)
          pw.Padding(
            padding: const pw.EdgeInsets.only(top: 1),
            child: pw.Text(e.company, style: pw.TextStyle(fontSize: 9, color: primary)),
          ),
        if (e.description.isNotEmpty) ...[
          pw.SizedBox(height: 2),
          pw.Text(e.description, style: pw.TextStyle(fontSize: 9, lineSpacing: 1.3)),
        ],
        if (e.highlights.isNotEmpty) ...[
          pw.SizedBox(height: 2),
          ...e.highlights.map((h) => pw.Text(
                '- $h',
                style: pw.TextStyle(fontSize: 8, color: primary),
              )),
        ],
        pw.SizedBox(height: compact ? 6 : 10),
      ],
    );
  }

  pw.Widget pdfEducationItem(Education e) {
    final dateStr = dateRangeString(e.startDate, e.endDate);
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Expanded(
              child: pw.Text(
                '${e.degree}${e.field.isNotEmpty ? ' in ${e.field}' : ''}',
                style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
              ),
            ),
            if (dateStr.isNotEmpty)
              pw.Text(dateStr, style: pw.TextStyle(fontSize: 8, color: PdfColors.grey)),
          ],
        ),
        if (e.institution.isNotEmpty)
          pw.Padding(
            padding: const pw.EdgeInsets.only(top: 1),
            child: pw.Row(
              children: [
                pw.Text(e.institution, style: pw.TextStyle(fontSize: 9, color: PdfColors.grey)),
                if (e.gpa != null) ...[
                  pw.SizedBox(width: 8),
                  pw.Text('GPA: ${e.gpa}', style: pw.TextStyle(fontSize: 9, color: PdfColors.grey)),
                ],
              ],
            ),
          ),
        pw.SizedBox(height: 8),
      ],
    );
  }

  pw.Widget pdfProjectItem(Project p, PdfColor primary) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(p.name, style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
        if (p.techStack.isNotEmpty)
          pw.Text(p.techStack, style: pw.TextStyle(fontSize: 8, color: primary)),
        if (p.description.isNotEmpty) ...[
          pw.SizedBox(height: 2),
          pw.Text(p.description, style: pw.TextStyle(fontSize: 9)),
        ],
        pw.SizedBox(height: 8),
      ],
    );
  }

  pw.Widget pdfCertificationItem(Certification c) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 4),
      child: pw.Row(
        children: [
          pw.Expanded(
            child: pw.Text(c.name, style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
          ),
          if (c.issuer.isNotEmpty || c.date != null)
            pw.Text(
              '${c.issuer}${c.issuer.isNotEmpty && c.date != null ? ' - ' : ''}${c.date != null ? c.date!.year.toString() : ''}',
              style: pw.TextStyle(fontSize: 8, color: PdfColors.grey),
            ),
        ],
      ),
    );
  }

  pw.Widget pdfSkillChips(List<Skill> skills, PdfColor primary) {
    return pw.Wrap(
      spacing: 4,
      runSpacing: 4,
      children: skills
          .where((s) => s.name.isNotEmpty)
          .map((s) => pw.Container(
                padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: pw.BoxDecoration(
                  color: lighten(primary, 0.85),
                  borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
                ),
                child: pw.Text(s.name, style: pw.TextStyle(fontSize: 8, color: primary)),
              ))
          .toList(),
    );
  }

  pw.Widget pdfSkillProgressBar(Skill s, PdfColor primary, {double maxWidth = 120}) {
    final barWidth = maxWidth * (s.level / 5);
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 3),
      child: pw.Row(
        children: [
          pw.SizedBox(width: 80, child: pw.Text(s.name, style: pw.TextStyle(fontSize: 8, color: PdfColors.white))),
          pw.SizedBox(
            width: maxWidth,
            height: 4,
            child: pw.Stack(
              children: [
                pw.Container(height: 4, decoration: pw.BoxDecoration(
                  color: whiteWithOpacity(0.38),
                  borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)),
                )),
                pw.Container(
                  width: barWidth,
                  height: 4,
                  decoration: pw.BoxDecoration(
                    color: PdfColors.white,
                    borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget pdfLanguageInline(List<Language> languages) {
    final items = languages.where((l) => l.name.isNotEmpty).map((l) {
      final level = l.level.isNotEmpty ? ' (${l.level})' : '';
      return '${l.name}$level';
    }).join('  -  ');
    if (items.isEmpty) return pw.SizedBox();
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 6),
      child: pw.Text(items, style: pw.TextStyle(fontSize: 9, color: PdfColors.grey)),
    );
  }

  pw.Widget pdfSidebarSectionTitle(String title, {double fontSize = 9}) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 4),
      child: pw.Text(
        title.toUpperCase(),
        style: pw.TextStyle(
          fontSize: fontSize,
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.white,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  pw.Widget pdfSidebarDivider() {
    return pw.Container(
      height: 0.5,
      margin: const pw.EdgeInsets.only(bottom: 6),
      color: whiteWithOpacity(0.70),
    );
  }

  pw.Widget pdfContactItem(String label, String value) {
    if (value.isEmpty) return pw.SizedBox();
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 2),
      child: pw.Text(
        '$label: $value',
        style: pw.TextStyle(fontSize: 8, color: PdfColors.grey),
      ),
    );
  }
}
