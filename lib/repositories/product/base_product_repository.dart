import 'package:qb_admin/models/models.dart';

abstract class BaseProductRepository {
  Stream<List<Product>> getAllProducts();
}
