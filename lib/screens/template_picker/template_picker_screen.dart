import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../../providers/cv_provider.dart';
import '../../data/models/cv_data.dart';
import '../../core/constants/app_constants.dart';

class TemplatePickerScreen extends ConsumerWidget {
  const TemplatePickerScreen({super.key});

  static const templateNames = {
    'classic': 'Classic',
    'modern': 'Modern',
    'minimal': 'Minimal',
    'creative': 'Creative',
    'executive': 'Executive',
    'material': 'Material You',
    'sidebar_bold': 'Sidebar Bold',
    'timeline': 'Timeline',
  };

  static const templateDescs = {
    'classic': 'Two-column traditional layout',
    'modern': 'Single-column with gradient header',
    'minimal': 'Clean, minimalist design',
    'creative': 'Bold colors with timeline',
    'executive': 'Dark navy with gold accents',
    'material': 'Card-based Material 3 design',
    'sidebar_bold': 'Bold gradient sidebar layout',
    'timeline': 'Chronological timeline layout',
  };

  static const templateIcons = {
    'classic': Icons.article,
    'modern': Icons.web_stories,
    'minimal': Icons.density_small,
    'creative': Icons.palette,
    'executive': Icons.workspace_premium,
    'material': Icons.widgets_rounded,
    'sidebar_bold': Icons.view_sidebar_rounded,
    'timeline': Icons.timeline_rounded,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cv = ref.watch(currentCvProvider);
    if (cv == null) return const Scaffold(body: Center(child: Text('No CV')));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Template'),
        actions: [
          IconButton(
            icon: const Icon(Icons.color_lens),
            onPressed: () => _pickColor(context, ref, cv),
            tooltip: 'Accent color',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 8),
          Row(
            children: [
              const Text('Accent Color',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () => _pickColor(context, ref, cv),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Color(cv.primaryColor),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...AppConstants.templateIds
              .map((id) => _templateCard(context, ref, cv, id)),
        ],
      ),
    );
  }

  Widget _templateCard(
      BuildContext context, WidgetRef ref, CVData cv, String id) {
    final selected = cv.templateId == id;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: selected ? Color(cv.primaryColor) : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          ref
              .read(currentCvProvider.notifier)
              .update(cv.copyWith(templateId: id));
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: selected
                      ? Color(cv.primaryColor)
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  templateIcons[id] ?? Icons.article,
                  color: selected ? Colors.white : Colors.grey.shade600,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      templateNames[id] ?? id,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: selected ? Color(cv.primaryColor) : null),
                    ),
                    const SizedBox(height: 2),
                    Text(templateDescs[id] ?? '',
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 12)),
                  ],
                ),
              ),
              if (selected)
                Icon(Icons.check_circle, color: Color(cv.primaryColor)),
            ],
          ),
        ),
      ),
    );
  }

  void _pickColor(BuildContext context, WidgetRef ref, CVData cv) {
    Color current = Color(cv.primaryColor);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Pick Accent Color'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: current,
            onColorChanged: (color) => current = color,
            enableAlpha: false,
            labelTypes: const [],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref
                  .read(currentCvProvider.notifier)
                  .update(cv.copyWith(primaryColor: current.toARGB32()));
              Navigator.pop(ctx);
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }
}
