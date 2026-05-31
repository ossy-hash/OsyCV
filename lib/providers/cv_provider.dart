import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cv_maker/data/models/cv_data.dart';
import 'package:cv_maker/data/repositories/cv_repository.dart';

final cvRepositoryProvider = Provider<CVRepository>((ref) {
  throw UnimplementedError('Override this provider in main.dart');
});

final cvListProvider = NotifierProvider<CVListNotifier, List<CVData>>(CVListNotifier.new);

final currentCvProvider = NotifierProvider<CurrentCVNotifier, CVData?>(CurrentCVNotifier.new);

class CVListNotifier extends Notifier<List<CVData>> {
  late final CVRepository _repository;

  @override
  List<CVData> build() {
    _repository = ref.read(cvRepositoryProvider);
    return _repository.loadAll();
  }

  void refresh() {
    state = _repository.loadAll();
  }

  Future<String> createNew() async {
    final cv = CVData(title: 'Untitled CV');
    await _repository.save(cv);
    state = _repository.loadAll();
    return cv.id;
  }

  Future<void> duplicate(String id) async {
    _repository.duplicate(id);
    state = _repository.loadAll();
  }

  Future<void> delete(String id) async {
    await _repository.delete(id);
    state = _repository.loadAll();
  }

  Future<void> deleteAll() async {
    await _repository.deleteAll();
    state = _repository.loadAll();
  }
}

class CurrentCVNotifier extends Notifier<CVData?> {
  late final CVRepository _repository;

  @override
  CVData? build() {
    _repository = ref.read(cvRepositoryProvider);
    return null;
  }

  void load(String id) {
    state = _repository.getById(id);
  }

  void set(CVData cv) {
    state = cv;
  }

  Future<void> save() async {
    final cv = state;
    if (cv == null) return;
    final updated = cv.copyWith();
    state = updated;
    await _repository.save(updated);
  }

  Future<void> update(CVData cv) async {
    state = cv;
    await _repository.save(cv);
  }

  Future<void> updateAndKeep(CVData cv) async {
    state = cv;
  }

  Future<void> deleteCurrent() async {
    final cv = state;
    if (cv == null) return;
    await _repository.delete(cv.id);
    state = null;
  }
}
