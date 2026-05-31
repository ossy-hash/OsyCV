import 'package:flutter/material.dart';
import '../../data/models/certification.dart';
import '../../core/utils/helpers.dart';
import 'form_widget.dart';

class CertificationFormWidget extends FormWidget<Certification> {
  final Certification certification;
  const CertificationFormWidget({super.key, required this.certification});

  @override
  State<CertificationFormWidget> createState() => _CertificationFormWidgetState();
}

class _CertificationFormWidgetState extends State<CertificationFormWidget> implements FormWidgetState<Certification> {
  late TextEditingController _nameCtrl;
  late TextEditingController _issuerCtrl;
  late TextEditingController _urlCtrl;
  DateTime? _date;

  @override
  void initState() {
    super.initState();
    final c = widget.certification;
    _nameCtrl = TextEditingController(text: c.name);
    _issuerCtrl = TextEditingController(text: c.issuer);
    _urlCtrl = TextEditingController(text: c.url);
    _date = c.date;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _issuerCtrl.dispose();
    _urlCtrl.dispose();
    super.dispose();
  }

  @override
  Certification getData() => Certification(
        id: widget.certification.id,
        name: _nameCtrl.text,
        issuer: _issuerCtrl.text,
        date: _date,
        url: _urlCtrl.text,
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Certification Name', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        TextField(controller: _nameCtrl, decoration: const InputDecoration(hintText: 'e.g. AWS Certified Developer')),
        const SizedBox(height: 12),
        const Text('Issuer', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        TextField(controller: _issuerCtrl, decoration: const InputDecoration(hintText: 'e.g. Amazon Web Services')),
        const SizedBox(height: 12),
        const Text('Date', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        OutlinedButton(
          onPressed: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: _date ?? DateTime.now(),
              firstDate: DateTime(1950),
              lastDate: DateTime.now(),
            );
            if (date != null) setState(() => _date = date);
          },
          child: Text(_date != null ? formatDate(_date) : 'Select date'),
        ),
        const SizedBox(height: 12),
        const Text('Credential URL (optional)', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        TextField(controller: _urlCtrl, decoration: const InputDecoration(hintText: 'https://...')),
      ],
    );
  }
}
