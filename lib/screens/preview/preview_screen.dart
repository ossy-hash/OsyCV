import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/cv_provider.dart';
import '../../services/pdf_service.dart';
import '../../data/models/cv_data.dart';
import '../../widgets/templates/classic/classic_preview.dart';
import '../../widgets/templates/modern/modern_preview.dart';
import '../../widgets/templates/minimal/minimal_preview.dart';
import '../../widgets/templates/creative/creative_preview.dart';
import '../../widgets/templates/executive/executive_preview.dart';
import '../../widgets/templates/material/material_preview.dart';
import '../../widgets/templates/sidebar_bold/sidebar_bold_preview.dart';
import '../../widgets/templates/timeline/timeline_preview.dart';

class PreviewScreen extends ConsumerWidget {
  const PreviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cv = ref.watch(currentCvProvider);
    if (cv == null) {
      return const Scaffold(body: Center(child: Text('No CV selected')));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview'),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () async {
              final pdfService = PdfService();
              await pdfService.previewPdf(cv);
            },
            tooltip: 'PDF Preview',
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () async {
              final pdfService = PdfService();
              await pdfService.sharePdf(cv);
            },
            tooltip: 'Share PDF',
          ),
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () async {
              final pdfService = PdfService();
              await pdfService.printPdf(cv);
            },
            tooltip: 'Print',
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: RepaintBoundary(
            child: _buildPreview(context, cv),
          ),
        ),
      ),
    );
  }

  Widget _buildPreview(BuildContext context, CVData cv) {
    switch (cv.templateId) {
      case 'modern':
        return ModernPreview(cv: cv).build(context);
      case 'minimal':
        return MinimalPreview(cv: cv).build(context);
      case 'creative':
        return CreativePreview(cv: cv).build(context);
      case 'executive':
        return ExecutivePreview(cv: cv).build(context);
      case 'material':
        return MaterialPreview(cv: cv).build(context);
      case 'sidebar_bold':
        return SidebarBoldPreview(cv: cv).build(context);
      case 'timeline':
        return TimelinePreview(cv: cv).build(context);
      default:
        return ClassicPreview(cv: cv).build(context);
    }
  }
}
