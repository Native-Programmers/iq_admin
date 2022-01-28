import 'package:qb_admin/models/models.dart';

abstract class BaseCategoryRepository {
  Stream<List<Categories>> getAllCategories();
}
