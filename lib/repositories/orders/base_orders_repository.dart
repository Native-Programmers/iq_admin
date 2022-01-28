import 'package:qb_admin/models/models.dart';

abstract class BaseOrdersRepository {
  Stream<List<Orders>> getAllOrders();
}
