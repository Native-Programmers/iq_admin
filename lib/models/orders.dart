import 'package:cloud_firestore/cloud_firestore.dart';

class Orders {
  Map customerAddress;
  Map customerDetails;
  String customerEmail;
  List products;
  String subtotal;
  String total;
  String deliveryFee;
  String userId;
  String status;

  Orders(
      {required this.customerAddress,
      required this.customerDetails,
      required this.customerEmail,
      required this.deliveryFee,
      required this.products,
      required this.subtotal,
      required this.total,
      required this.userId,
      required this.status});
  @override
  List<Object?> get props => [
        userId,
        total,
        subtotal,
        products,
        deliveryFee,
        customerAddress,
        customerDetails,
        customerEmail,
        status
      ];

  static Orders fromSnapshot(DocumentSnapshot snap) {
    Orders orders = Orders(
      userId: snap.id,
      customerAddress: snap['customerAddress'],
      deliveryFee: snap['delivery'],
      customerEmail: snap['email'],
      customerDetails: snap['customerDetails'],
      total: snap['total'],
      subtotal: snap['subtotal'],
      products: snap['product_id'],
      status: snap['status'],
    );
    return orders;
  }
}
