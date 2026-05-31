import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../providers/cv_provider.dart';
import '../../data/models/cv_data.dart';
import '../../widgets/forms/form_widget.dart';
import '../../widgets/forms/experience_form.dart';
import '../../widgets/forms/education_form.dart';
import '../../widgets/forms/skill_form.dart';
import '../../widgets/forms/language_form.dart';
import '../../widgets/forms/project_form.dart';
import '../../widgets/forms/certification_form.dart';

class EditorScreen extends ConsumerStatefulWidget {
  const EditorScreen({super.key});

  @override
  ConsumerState<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends ConsumerState<EditorScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  CVData? get cv => ref.read(currentCvProvider);

  void _updateCv(CVData updated) {
    ref.read(currentCvProvider.notifier).updateAndKeep(updated);
  }

  void _saveAndRefresh() {
    ref.read(currentCvProvider.notifier).save();
    ref.invalidate(cvListProvider);
  }

  String get _currentCvId {
    final c = ref.read(currentCvProvider);
    return c?.id ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final currentCv = ref.watch(currentCvProvider);
    if (currentCv == null) {
      return const Scaffold(body: Center(child: Text('No CV selected')));
    }

    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            final controller = TextEditingController(text: currentCv.title);
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Rename CV'),
                content: TextField(
                    controller: controller,
                    autofocus: true,
                    decoration: const InputDecoration(hintText: 'CV title')),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Cancel')),
                  TextButton(
                    onPressed: () {
                      ref.read(currentCvProvider.notifier).update(
                          currentCv.copyWith(title: controller.text));
                      Navigator.pop(ctx);
                    },
                    child: const Text('Rename'),
                  ),
                ],
              ),
            );
          },
          child: Text(currentCv.title,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.palette),
            onPressed: () {
              context.pushNamed('template-picker',
                  pathParameters: {'cvId': _currentCvId});
            },
          ),
          IconButton(
            icon: const Icon(Icons.visibility),
            onPressed: () {
              _saveAndRefresh();
              context.pushNamed('preview',
                  pathParameters: {'cvId': _currentCvId});
            },
            tooltip: 'Preview',
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveAndRefresh,
            tooltip: 'Save',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          tabs: const [
            Tab(text: 'Personal'),
            Tab(text: 'Summary'),
            Tab(text: 'Experience'),
            Tab(text: 'Education'),
            Tab(text: 'Skills'),
            Tab(text: 'More'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPersonalTab(currentCv),
          _buildSummaryTab(currentCv),
          _buildExperienceTab(currentCv),
          _buildEducationTab(currentCv),
          _buildSkillsTab(currentCv),
          _buildMoreTab(currentCv),
        ],
      ),
    );
  }

  Widget _buildPersonalTab(CVData cv) {
    final p = cv.personalInfo;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          GestureDetector(
            onTap: () async {
              try {
                final picker = ImagePicker();
                final file = await picker.pickImage(
                    source: ImageSource.gallery,
                    maxWidth: 512,
                    maxHeight: 512);
                if (file != null) {
                  _updateCv(
                      cv.copyWith(personalInfo: p.copyWith(photoPath: file.path)));
                }
              } catch (_) {}
            },
            child: CircleAvatar(
              radius: 40,
              backgroundColor:
                  Color(cv.primaryColor).withValues(alpha: 0.1),
              backgroundImage: p.photoPath.isNotEmpty &&
                      File(p.photoPath).existsSync()
                  ? FileImage(File(p.photoPath))
                  : null,
              child: p.photoPath.isEmpty
                  ? Icon(Icons.camera_alt,
                      size: 28, color: Color(cv.primaryColor))
                  : null,
            ),
          ),
          const SizedBox(height: 24),
          _buildField('Full Name', p.fullName,
              (v) => _updateCv(cv.copyWith(personalInfo: p.copyWith(fullName: v)))),
          _buildField('Job Title', p.jobTitle,
              (v) => _updateCv(cv.copyWith(personalInfo: p.copyWith(jobTitle: v)))),
          _buildField('Email', p.email,
              (v) => _updateCv(cv.copyWith(personalInfo: p.copyWith(email: v))),
              keyboardType: TextInputType.emailAddress),
          _buildField('Phone', p.phone,
              (v) => _updateCv(cv.copyWith(personalInfo: p.copyWith(phone: v))),
              keyboardType: TextInputType.phone),
          _buildField('Address', p.address,
              (v) => _updateCv(cv.copyWith(personalInfo: p.copyWith(address: v)))),
          _buildField('LinkedIn URL', p.linkedIn,
              (v) => _updateCv(cv.copyWith(personalInfo: p.copyWith(linkedIn: v)))),
          _buildField('GitHub URL', p.github,
              (v) => _updateCv(cv.copyWith(personalInfo: p.copyWith(github: v)))),
          _buildField('Portfolio URL', p.portfolio,
              (v) => _updateCv(cv.copyWith(personalInfo: p.copyWith(portfolio: v)))),
          _buildField('Nationality', p.nationality,
              (v) => _updateCv(
                  cv.copyWith(personalInfo: p.copyWith(nationality: v)))),
        ],
      ),
    );
  }

  Widget _buildSummaryTab(CVData cv) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Professional Summary',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text('Brief overview of your qualifications and career goals.',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
          const SizedBox(height: 16),
          TextFormField(
            initialValue: cv.summary,
            maxLines: 8,
            decoration: const InputDecoration(
                hintText: 'Write your professional summary here...',
                alignLabelWithHint: true),
            onChanged: (v) => _updateCv(cv.copyWith(summary: v)),
          ),
        ],
      ),
    );
  }

  Widget _buildExperienceTab(CVData cv) {
    return _buildListSection<Experience>(
      title: 'Experience',
      items: cv.experiences,
      addLabel: 'Add Experience',
      onAdd: () =>
          _updateCv(cv.copyWith(experiences: [...cv.experiences, Experience()])),
      onEdit: (index) => _editItemDialog2<Experience>(
        context: context,
        builder: (ctx, key) =>
            ExperienceFormWidget(key: key, experience: cv.experiences[index]),
        onSave: (updated) {
          final list = [...cv.experiences];
          list[index] = updated;
          _updateCv(cv.copyWith(experiences: list));
        },
      ),
      onDelete: (index) {
        final list = [...cv.experiences];
        list.removeAt(index);
        _updateCv(cv.copyWith(experiences: list));
      },
      itemBuilder: (e) =>
          '${e.position.isNotEmpty ? e.position : 'New Position'}${e.company.isNotEmpty ? ' @ ${e.company}' : ''}',
    );
  }

  Widget _buildEducationTab(CVData cv) {
    return _buildListSection<Education>(
      title: 'Education',
      items: cv.educations,
      addLabel: 'Add Education',
      onAdd: () =>
          _updateCv(cv.copyWith(educations: [...cv.educations, Education()])),
      onEdit: (index) => _editItemDialog2<Education>(
        context: context,
        builder: (ctx, key) =>
            EducationFormWidget(key: key, education: cv.educations[index]),
        onSave: (updated) {
          final list = [...cv.educations];
          list[index] = updated;
          _updateCv(cv.copyWith(educations: list));
        },
      ),
      onDelete: (index) {
        final list = [...cv.educations];
        list.removeAt(index);
        _updateCv(cv.copyWith(educations: list));
      },
      itemBuilder: (e) =>
          '${e.degree.isNotEmpty ? e.degree : 'New Degree'}${e.institution.isNotEmpty ? ' @ ${e.institution}' : ''}',
    );
  }

  Widget _buildSkillsTab(CVData cv) {
    return _buildListSection<Skill>(
      title: 'Skills',
      items: cv.skills,
      addLabel: 'Add Skill',
      onAdd: () => _updateCv(cv.copyWith(skills: [...cv.skills, Skill()])),
      onEdit: (index) => _editItemDialog2<Skill>(
        context: context,
        builder: (ctx, key) =>
            SkillFormWidget(key: key, skill: cv.skills[index]),
        onSave: (updated) {
          final list = [...cv.skills];
          list[index] = updated;
          _updateCv(cv.copyWith(skills: list));
        },
      ),
      onDelete: (index) {
        final list = [...cv.skills];
        list.removeAt(index);
        _updateCv(cv.copyWith(skills: list));
      },
      itemBuilder: (s) => '${s.name.isNotEmpty ? s.name : 'New Skill'} (${s.category})',
    );
  }

  Widget _buildMoreTab(CVData cv) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionToggle(
              cv, 'Show Photo', cv.showPhoto, (v) => _updateCv(cv.copyWith(showPhoto: v))),
          _buildSectionToggle(cv, 'Show Summary', cv.showSummary,
              (v) => _updateCv(cv.copyWith(showSummary: v))),
          _buildSectionToggle(cv, 'Show Experience', cv.showExperience,
              (v) => _updateCv(cv.copyWith(showExperience: v))),
          _buildSectionToggle(cv, 'Show Education', cv.showEducation,
              (v) => _updateCv(cv.copyWith(showEducation: v))),
          _buildSectionToggle(cv, 'Show Skills', cv.showSkills,
              (v) => _updateCv(cv.copyWith(showSkills: v))),
          _buildSectionToggle(cv, 'Show Languages', cv.showLanguages,
              (v) => _updateCv(cv.copyWith(showLanguages: v))),
          _buildSectionToggle(cv, 'Show Projects', cv.showProjects,
              (v) => _updateCv(cv.copyWith(showProjects: v))),
          _buildSectionToggle(cv, 'Show Certifications', cv.showCertifications,
              (v) => _updateCv(cv.copyWith(showCertifications: v))),
          const Divider(height: 32),
          const Text('Languages',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          ...cv.languages.asMap().entries.map((entry) {
            final i = entry.key;
            final l = entry.value;
            return Card(
              child: ListTile(
                title: Text(l.name.isNotEmpty ? l.name : 'New Language'),
                subtitle: Text(l.level),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      onPressed: () => _editItemDialog2<Language>(
                        context: context,
                        builder: (ctx, key) =>
                            LanguageFormWidget(key: key, language: l),
                        onSave: (Language updated) {
                          final list = [...cv.languages];
                          list[i] = updated;
                          _updateCv(cv.copyWith(languages: list));
                        },
                      ),
                    ),
                    IconButton(
                        icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                        onPressed: () {
                          final list = [...cv.languages];
                          list.removeAt(i);
                          _updateCv(cv.copyWith(languages: list));
                        }),
                  ],
                ),
              ),
            );
          }),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: OutlinedButton.icon(
              onPressed: () => _updateCv(
                  cv.copyWith(languages: [...cv.languages, Language()])),
              icon: const Icon(Icons.add),
              label: const Text('Add Language'),
            ),
          ),
          const Divider(height: 32),
          const Text('Projects',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          ...cv.projects.asMap().entries.map((entry) {
            final i = entry.key;
            final p = entry.value;
            return Card(
              child: ListTile(
                title: Text(p.name.isNotEmpty ? p.name : 'New Project'),
                subtitle: p.techStack.isNotEmpty ? Text(p.techStack) : null,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      onPressed: () => _editItemDialog2<Project>(
                        context: context,
                        builder: (ctx, key) =>
                            ProjectFormWidget(key: key, project: p),
                        onSave: (Project updated) {
                          final list = [...cv.projects];
                          list[i] = updated;
                          _updateCv(cv.copyWith(projects: list));
                        },
                      ),
                    ),
                    IconButton(
                        icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                        onPressed: () {
                          final list = [...cv.projects];
                          list.removeAt(i);
                          _updateCv(cv.copyWith(projects: list));
                        }),
                  ],
                ),
              ),
            );
          }),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: OutlinedButton.icon(
              onPressed: () => _updateCv(
                  cv.copyWith(projects: [...cv.projects, Project()])),
              icon: const Icon(Icons.add),
              label: const Text('Add Project'),
            ),
          ),
          const Divider(height: 32),
          const Text('Certifications',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          ...cv.certifications.asMap().entries.map((entry) {
            final i = entry.key;
            final c = entry.value;
            return Card(
              child: ListTile(
                title: Text(c.name.isNotEmpty ? c.name : 'New Certification'),
                subtitle: c.issuer.isNotEmpty ? Text(c.issuer) : null,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      onPressed: () => _editItemDialog2<Certification>(
                        context: context,
                        builder: (ctx, key) =>
                            CertificationFormWidget(key: key, certification: c),
                        onSave: (Certification updated) {
                          final list = [...cv.certifications];
                          list[i] = updated;
                          _updateCv(cv.copyWith(certifications: list));
                        },
                      ),
                    ),
                    IconButton(
                        icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                        onPressed: () {
                          final list = [...cv.certifications];
                          list.removeAt(i);
                          _updateCv(cv.copyWith(certifications: list));
                        }),
                  ],
                ),
              ),
            );
          }),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: OutlinedButton.icon(
              onPressed: () => _updateCv(
                  cv.copyWith(certifications: [...cv.certifications, Certification()])),
              icon: const Icon(Icons.add),
              label: const Text('Add Certification'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField(String label, String value, Function(String) onChanged,
      {TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        initialValue: value,
        decoration: InputDecoration(labelText: label),
        keyboardType: keyboardType,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildSectionToggle(
      CVData cv, String label, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      title: Text(label),
      value: value,
      onChanged: onChanged,
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildListSection<T>({
    required String title,
    required List<T> items,
    required String addLabel,
    required VoidCallback onAdd,
    required Function(int) onEdit,
    required Function(int) onDelete,
    required String Function(T) itemBuilder,
  }) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: onAdd,
              tooltip: addLabel,
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (items.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Text('No items yet. Tap + to add.',
                  style: TextStyle(color: Colors.grey.shade500)),
            ),
          ),
        ...items.asMap().entries.map((entry) {
          final i = entry.key;
          final item = entry.value;
          return Card(
            child: ListTile(
              title: Text(itemBuilder(item), overflow: TextOverflow.ellipsis),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, size: 20),
                    onPressed: () => onEdit(i),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                    onPressed: () => onDelete(i),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Future<void> _editItemDialog2<T>({
    required BuildContext context,
    required FormWidget<T> Function(BuildContext, GlobalKey) builder,
    required Function(T) onSave,
  }) {
    final formKey = GlobalKey();
    return showDialog(
      context: context,
      builder: (ctx) {
        final form = builder(ctx, formKey);
        return AlertDialog(
          content: SizedBox(
              width: 400, child: SingleChildScrollView(child: form)),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel')),
            TextButton(
              onPressed: () {
                final data =
                    (formKey.currentState as FormWidgetState<T>).getData();
                onSave(data);
                Navigator.pop(ctx);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
