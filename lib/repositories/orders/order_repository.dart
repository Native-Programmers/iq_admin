import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qb_admin/models/models.dart';
import 'base_orders_repository.dart';

class OrdersRepository extends BaseOrdersRepository {
  final FirebaseFirestore _firebaseFirestore;

  OrdersRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<Orders>> getAllOrders() {
    return _firebaseFirestore
        .collection('checkout')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Orders.fromSnapshot(doc)).toList();
    });
  }
}
