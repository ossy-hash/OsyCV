import '../models/cv_data.dart';

abstract class CVRepository {
  List<CVData> loadAll();
  CVData? getById(String id);
  Future<void> save(CVData cv);
  Future<void> delete(String id);
  Future<void> deleteAll();
  String duplicate(String id);
}
