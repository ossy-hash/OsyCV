import 'package:flutter/material.dart';
import '../../data/models/language.dart';
import '../../core/constants/app_constants.dart';
import 'form_widget.dart';

class LanguageFormWidget extends FormWidget<Language> {
  final Language language;
  const LanguageFormWidget({super.key, required this.language});

  @override
  State<LanguageFormWidget> createState() => _LanguageFormWidgetState();
}

class _LanguageFormWidgetState extends State<LanguageFormWidget> implements FormWidgetState<Language> {
  late TextEditingController _nameCtrl;
  String _level = '';

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.language.name);
    _level = widget.language.level;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  @override
  Language getData() => Language(
        id: widget.language.id,
        name: _nameCtrl.text,
        level: _level,
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Language', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        TextField(controller: _nameCtrl, decoration: const InputDecoration(hintText: 'e.g. English')),
        const SizedBox(height: 12),
        const Text('Proficiency', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        DropdownButtonFormField<String>(
          initialValue: _level,
          items: AppConstants.languageLevels.map((l) =>
              DropdownMenuItem(value: l, child: Text(l))).toList(),
          onChanged: (v) => setState(() => _level = v ?? 'B1 - Intermediate'),
          decoration: const InputDecoration(),
        ),
      ],
    );
  }
}
