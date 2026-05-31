import 'package:flutter/material.dart';
import '../../data/models/experience.dart';
import 'form_widget.dart';

class ExperienceFormWidget extends FormWidget<Experience> {
  final Experience experience;
  const ExperienceFormWidget({super.key, required this.experience});

  @override
  State<ExperienceFormWidget> createState() => _ExperienceFormWidgetState();
}

class _ExperienceFormWidgetState extends State<ExperienceFormWidget> implements FormWidgetState<Experience> {
  late TextEditingController _companyCtrl;
  late TextEditingController _positionCtrl;
  late TextEditingController _descriptionCtrl;
  late List<TextEditingController> _highlightCtls;
  bool _current = false;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    final e = widget.experience;
    _companyCtrl = TextEditingController(text: e.company);
    _positionCtrl = TextEditingController(text: e.position);
    _descriptionCtrl = TextEditingController(text: e.description);
    _highlightCtls = e.highlights.map((h) => TextEditingController(text: h)).toList();
    _current = e.current;
    _startDate = e.startDate;
    _endDate = e.endDate;
  }

  @override
  void dispose() {
    _companyCtrl.dispose();
    _positionCtrl.dispose();
    _descriptionCtrl.dispose();
    for (final c in _highlightCtls) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Experience getData() => Experience(
        id: widget.experience.id,
        company: _companyCtrl.text,
        position: _positionCtrl.text,
        startDate: _startDate,
        endDate: _current ? null : _endDate,
        current: _current,
        description: _descriptionCtrl.text,
        highlights: _highlightCtls.map((c) => c.text).toList(),
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Company', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        TextField(controller: _companyCtrl, decoration: const InputDecoration(hintText: 'Company name')),
        const SizedBox(height: 12),
        const Text('Position', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        TextField(controller: _positionCtrl, decoration: const InputDecoration(hintText: 'Job title')),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Start Date', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  OutlinedButton(
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _startDate ?? DateTime.now(),
                        firstDate: DateTime(1950),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) setState(() => _startDate = date);
                    },
                    child: Text(_startDate != null
                        ? '${_startDate!.month}/${_startDate!.year}'
                        : 'Select date'),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('End Date', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  OutlinedButton(
                    onPressed: _current ? null : () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _endDate ?? DateTime.now(),
                        firstDate: DateTime(1950),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) setState(() => _endDate = date);
                    },
                    child: Text(_endDate != null
                        ? '${_endDate!.month}/${_endDate!.year}'
                        : _current ? 'Present' : 'Select date'),
                  ),
                ],
              ),
            ),
          ],
        ),
        CheckboxListTile(
          title: const Text('I currently work here'),
          value: _current,
          onChanged: (v) => setState(() => _current = v ?? false),
          contentPadding: EdgeInsets.zero,
          controlAffinity: ListTileControlAffinity.leading,
        ),
        const SizedBox(height: 12),
        const Text('Description', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        TextField(controller: _descriptionCtrl, maxLines: 3, decoration: const InputDecoration(hintText: 'Description')),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Highlights', style: TextStyle(fontWeight: FontWeight.w600)),
            IconButton(
              icon: const Icon(Icons.add_circle_outline, size: 20),
              onPressed: () => setState(() => _highlightCtls.add(TextEditingController())),
            ),
          ],
        ),
        ..._highlightCtls.asMap().entries.map((entry) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: entry.value,
                      decoration: InputDecoration(
                        hintText: 'Bullet point ${entry.key + 1}',
                        isDense: true,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline, color: Colors.red, size: 20),
                    onPressed: () => setState(() => _highlightCtls.removeAt(entry.key)),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}
