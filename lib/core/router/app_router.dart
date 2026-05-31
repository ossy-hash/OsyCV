import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/cv_provider.dart';
import '../../screens/dashboard/dashboard_screen.dart';
import '../../screens/editor/editor_screen.dart';
import '../../screens/preview/preview_screen.dart';
import '../../screens/template_picker/template_picker_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'dashboard',
        builder: (_, __) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/editor/:cvId',
        name: 'editor',
        builder: (_, state) {
          final cvId = state.pathParameters['cvId']!;
          return _CVLoader(cvId: cvId, child: const EditorScreen());
        },
        routes: [
          GoRoute(
            path: 'template-picker',
            name: 'template-picker',
            builder: (_, __) => const TemplatePickerScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/preview/:cvId',
        name: 'preview',
        builder: (_, state) {
          final cvId = state.pathParameters['cvId']!;
          return _CVLoader(cvId: cvId, child: const PreviewScreen());
        },
      ),
    ],
  );
});

class _CVLoader extends ConsumerStatefulWidget {
  final String cvId;
  final Widget child;

  const _CVLoader({required this.cvId, required this.child});

  @override
  ConsumerState<_CVLoader> createState() => _CVLoaderState();
}

class _CVLoaderState extends ConsumerState<_CVLoader> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(currentCvProvider.notifier).load(widget.cvId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
