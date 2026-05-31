import 'package:flutter/material.dart';
import '../../data/models/project.dart';
import 'form_widget.dart';

class ProjectFormWidget extends FormWidget<Project> {
  final Project project;
  const ProjectFormWidget({super.key, required this.project});

  @override
  State<ProjectFormWidget> createState() => _ProjectFormWidgetState();
}

class _ProjectFormWidgetState extends State<ProjectFormWidget> implements FormWidgetState<Project> {
  late TextEditingController _nameCtrl;
  late TextEditingController _descriptionCtrl;
  late TextEditingController _techStackCtrl;
  late TextEditingController _urlCtrl;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    final p = widget.project;
    _nameCtrl = TextEditingController(text: p.name);
    _descriptionCtrl = TextEditingController(text: p.description);
    _techStackCtrl = TextEditingController(text: p.techStack);
    _urlCtrl = TextEditingController(text: p.url);
    _startDate = p.startDate;
    _endDate = p.endDate;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descriptionCtrl.dispose();
    _techStackCtrl.dispose();
    _urlCtrl.dispose();
    super.dispose();
  }

  @override
  Project getData() => Project(
        id: widget.project.id,
        name: _nameCtrl.text,
        description: _descriptionCtrl.text,
        techStack: _techStackCtrl.text,
        url: _urlCtrl.text,
        startDate: _startDate,
        endDate: _endDate,
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Project Name', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        TextField(controller: _nameCtrl, decoration: const InputDecoration(hintText: 'Project name')),
        const SizedBox(height: 12),
        const Text('Description', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        TextField(controller: _descriptionCtrl, maxLines: 3, decoration: const InputDecoration(hintText: 'Brief description')),
        const SizedBox(height: 12),
        const Text('Tech Stack', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        TextField(controller: _techStackCtrl, decoration: const InputDecoration(hintText: 'e.g. Flutter, Firebase, Riverpod')),
        const SizedBox(height: 12),
        const Text('URL (optional)', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        TextField(controller: _urlCtrl, decoration: const InputDecoration(hintText: 'https://...')),
      ],
    );
  }
}
