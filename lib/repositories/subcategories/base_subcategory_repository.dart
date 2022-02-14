import 'package:qb_admin/models/subcategories_model.dart';

abstract class BaseSubCategoryRepository {
  Stream<List<SubCategories>> getAllSubCategories();
}
