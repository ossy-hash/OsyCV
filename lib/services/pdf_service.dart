import 'dart:typed_data';
import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import '../data/models/cv_data.dart';
import '../widgets/templates/classic/classic_pdf.dart';
import '../widgets/templates/modern/modern_pdf.dart';
import '../widgets/templates/minimal/minimal_pdf.dart';
import '../widgets/templates/creative/creative_pdf.dart';
import '../widgets/templates/executive/executive_pdf.dart';
import '../widgets/templates/material/material_pdf.dart';
import '../widgets/templates/sidebar_bold/sidebar_bold_pdf.dart';
import '../widgets/templates/timeline/timeline_pdf.dart';

class PdfService {
  Future<pw.Document> generatePdf(CVData cv) async {
    final doc = pw.Document();
    final pdfPage = _buildPdf(cv);
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(20),
        build: (context) => pdfPage,
      ),
    );
    return doc;
  }

  pw.Widget _buildPdf(CVData cv) {
    switch (cv.templateId) {
      case 'modern':
        return ModernPdfTemplate(cv: cv).build();
      case 'minimal':
        return MinimalPdfTemplate(cv: cv).build();
      case 'creative':
        return CreativePdfTemplate(cv: cv).build();
      case 'executive':
        return ExecutivePdfTemplate(cv: cv).build();
      case 'material':
        return MaterialPdfTemplate(cv: cv).build();
      case 'sidebar_bold':
        return SidebarBoldPdfTemplate(cv: cv).build();
      case 'timeline':
        return TimelinePdfTemplate(cv: cv).build();
      default:
        return ClassicPdfTemplate(cv: cv).build();
    }
  }

  Future<void> previewPdf(CVData cv) async {
    final doc = await generatePdf(cv);
    await Printing.layoutPdf(onLayout: (format) async => doc.save());
  }

  Future<void> sharePdf(CVData cv) async {
    final doc = await generatePdf(cv);
    final bytes = await doc.save();
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/${cv.title.replaceAll(' ', '_')}.pdf');
    await file.writeAsBytes(bytes);
    await Share.shareXFiles(
      [XFile(file.path)],
      subject: '${cv.personalInfo.fullName} - CV',
    );
  }

  Future<Uint8List> getPdfBytes(CVData cv) async {
    final doc = await generatePdf(cv);
    return doc.save();
  }

  Future<void> printPdf(CVData cv) async {
    final doc = await generatePdf(cv);
    await Printing.layoutPdf(onLayout: (format) async => doc.save());
  }
}
