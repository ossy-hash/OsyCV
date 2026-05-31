import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../providers/cv_provider.dart';
import '../../data/models/cv_data.dart';
import '../../widgets/logo_widget.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cvs = ref.watch(cvListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const LogoWidget(),
        actions: [
          if (cvs.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Delete All?'),
                    content: const Text('This will delete all your CVs.'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: const Text('Delete All', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
                if (confirmed == true) {
                  await ref.read(cvListProvider.notifier).deleteAll();
                }
              },
            ),
        ],
      ),
      body: cvs.isEmpty ? _buildEmptyState(context, ref) : _buildList(context, ref, cvs),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final id = await ref.read(cvListProvider.notifier).createNew();
          if (id.isNotEmpty && context.mounted) {
            context.goNamed('editor', pathParameters: {'cvId': id});
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('New CV'),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const LogoLargeWidget(),
          const SizedBox(height: 24),
          Text('No CVs yet', style: TextStyle(fontSize: 18, color: Colors.grey.shade500)),
          const SizedBox(height: 8),
          Text('Tap the button below to create your first CV',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade400)),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () async {
              final id = await ref.read(cvListProvider.notifier).createNew();
              if (id.isNotEmpty && context.mounted) {
                context.goNamed('editor', pathParameters: {'cvId': id});
              }
            },
            icon: const Icon(Icons.add),
            label: const Text('Create CV'),
          ),
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context, WidgetRef ref, List<CVData> cvs) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
      itemCount: cvs.length,
      itemBuilder: (context, index) {
        final cv = cvs[index];
        final dateStr = DateFormat('MMM d, yyyy').format(cv.updatedAt);
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              context.goNamed('editor', pathParameters: {'cvId': cv.id});
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Color(cv.primaryColor).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Icon(Icons.description, color: Color(cv.primaryColor)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(cv.title,
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            if (cv.personalInfo.fullName.isNotEmpty)
                              Text(cv.personalInfo.fullName,
                                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                            if (cv.personalInfo.fullName.isNotEmpty)
                              Text('  \u2022  ',
                                  style: TextStyle(color: Colors.grey.shade400, fontSize: 10)),
                            Text(dateStr,
                                style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) async {
                      if (value == 'duplicate') {
                        await ref.read(cvListProvider.notifier).duplicate(cv.id);
                      } else if (value == 'preview') {
                        if (context.mounted) {
                          context.goNamed('preview', pathParameters: {'cvId': cv.id});
                        }
                      } else if (value == 'delete') {
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Delete CV?'),
                            content: Text('Delete "${cv.title}"?'),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.pop(ctx, false),
                                  child: const Text('Cancel')),
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, true),
                                child:
                                    const Text('Delete', style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        );
                        if (confirmed == true) {
                          await ref.read(cvListProvider.notifier).delete(cv.id);
                        }
                      }
                    },
                    itemBuilder: (_) => [
                      const PopupMenuItem(
                          value: 'preview',
                          child: ListTile(
                              leading: Icon(Icons.visibility), title: Text('Preview'), dense: true)),
                      const PopupMenuItem(
                          value: 'duplicate',
                          child: ListTile(
                              leading: Icon(Icons.copy), title: Text('Duplicate'), dense: true)),
                      const PopupMenuItem(
                          value: 'delete',
                          child: ListTile(
                              leading: Icon(Icons.delete, color: Colors.red),
                              title: Text('Delete', style: TextStyle(color: Colors.red)),
                              dense: true)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
