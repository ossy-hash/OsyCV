import 'package:flutter/material.dart';
import '../../data/models/skill.dart';
import '../../core/constants/app_constants.dart';
import 'form_widget.dart';

class SkillFormWidget extends FormWidget<Skill> {
  final Skill skill;
  const SkillFormWidget({super.key, required this.skill});

  @override
  State<SkillFormWidget> createState() => _SkillFormWidgetState();
}

class _SkillFormWidgetState extends State<SkillFormWidget> implements FormWidgetState<Skill> {
  late TextEditingController _nameCtrl;
  String _category = '';
  int _level = 3;

  @override
  void initState() {
    super.initState();
    final s = widget.skill;
    _nameCtrl = TextEditingController(text: s.name);
    _category = s.category;
    _level = s.level;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  @override
  Skill getData() => Skill(
        id: widget.skill.id,
        name: _nameCtrl.text,
        category: _category,
        level: _level,
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Skill Name', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        TextField(controller: _nameCtrl, decoration: const InputDecoration(hintText: 'e.g. Flutter')),
        const SizedBox(height: 12),
        const Text('Category', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        DropdownButtonFormField<String>(
          initialValue: _category,
          items: ['Technical', 'Design', 'Management', 'Language', 'Soft Skill', 'Other'].map((c) =>
              DropdownMenuItem(value: c, child: Text(c))).toList(),
          onChanged: (v) => setState(() => _category = v ?? 'Technical'),
          decoration: const InputDecoration(),
        ),
        const SizedBox(height: 12),
        const Text('Proficiency Level', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: Slider(
                value: _level.toDouble(),
                min: 1,
                max: 5,
                divisions: 4,
                label: AppConstants.skillLevels[_level - 1],
                onChanged: (v) => setState(() => _level = v.round()),
              ),
            ),
            SizedBox(
              width: 80,
              child: Text(AppConstants.skillLevels[_level - 1], style: const TextStyle(fontSize: 12)),
            ),
          ],
        ),
      ],
    );
  }
}
