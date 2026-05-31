import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cv_maker/app.dart';
import 'package:cv_maker/models/cv_data.dart';
import 'package:cv_maker/services/storage_service.dart';
import 'package:cv_maker/providers/cv_provider.dart';

class _MockStorage extends StorageService {
  @override
  List<CVData> loadAll() => [];
  @override
  CVData? get(String id) => null;
  @override
  Future<void> save(CVData cv) async {}
  @override
  Future<void> delete(String id) async {}
}

void main() {
  testWidgets('App loads and shows dashboard', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          storageServiceProvider.overrideWithValue(_MockStorage()),
        ],
        child: const CVMakerApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('CV Maker'), findsOneWidget);
  });
}
