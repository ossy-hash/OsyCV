import 'package:flutter/material.dart';
import '../../data/models/education.dart';
import 'form_widget.dart';

class EducationFormWidget extends FormWidget<Education> {
  final Education education;
  const EducationFormWidget({super.key, required this.education});

  @override
  State<EducationFormWidget> createState() => _EducationFormWidgetState();
}

class _EducationFormWidgetState extends State<EducationFormWidget> implements FormWidgetState<Education> {
  late TextEditingController _institutionCtrl;
  late TextEditingController _degreeCtrl;
  late TextEditingController _fieldCtrl;
  late TextEditingController _descriptionCtrl;
  late TextEditingController _gpaCtrl;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    final e = widget.education;
    _institutionCtrl = TextEditingController(text: e.institution);
    _degreeCtrl = TextEditingController(text: e.degree);
    _fieldCtrl = TextEditingController(text: e.field);
    _descriptionCtrl = TextEditingController(text: e.description);
    _gpaCtrl = TextEditingController(text: e.gpa?.toStringAsFixed(1) ?? '');
    _startDate = e.startDate;
    _endDate = e.endDate;
  }

  @override
  void dispose() {
    _institutionCtrl.dispose();
    _degreeCtrl.dispose();
    _fieldCtrl.dispose();
    _descriptionCtrl.dispose();
    _gpaCtrl.dispose();
    super.dispose();
  }

  @override
  Education getData() => Education(
        id: widget.education.id,
        institution: _institutionCtrl.text,
        degree: _degreeCtrl.text,
        field: _fieldCtrl.text,
        startDate: _startDate,
        endDate: _endDate,
        gpa: double.tryParse(_gpaCtrl.text),
        description: _descriptionCtrl.text,
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Institution', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        TextField(controller: _institutionCtrl, decoration: const InputDecoration(hintText: 'School / University')),
        const SizedBox(height: 12),
        const Text('Degree', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        TextField(controller: _degreeCtrl, decoration: const InputDecoration(hintText: 'e.g. Bachelor of Science')),
        const SizedBox(height: 12),
        const Text('Field of Study', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        TextField(controller: _fieldCtrl, decoration: const InputDecoration(hintText: 'e.g. Computer Science')),
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
                        initialDate: _startDate ?? DateTime(2020),
                        firstDate: DateTime(1950),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) setState(() => _startDate = date);
                    },
                    child: Text(_startDate != null ? '${_startDate!.month}/${_startDate!.year}' : 'Select'),
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
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _endDate ?? DateTime.now(),
                        firstDate: DateTime(1950),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) setState(() => _endDate = date);
                    },
                    child: Text(_endDate != null ? '${_endDate!.month}/${_endDate!.year}' : 'Select'),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Text('GPA (optional)', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        TextField(controller: _gpaCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(hintText: 'e.g. 3.8')),
        const SizedBox(height: 12),
        const Text('Description (optional)', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        TextField(controller: _descriptionCtrl, maxLines: 2, decoration: const InputDecoration(hintText: 'Notable achievements...')),
      ],
    );
  }
}
