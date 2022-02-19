import 'package:cloud_firestore/cloud_firestore.dart';

class Orders {
  Map customerAddress;
  Map customerDetails;
  String customerEmail;
  List products;
  String subtotal;
  String total;
  String deliveryFee;
  String orderId;
  String status;

  Orders(
      {required this.customerAddress,
      required this.customerDetails,
      required this.customerEmail,
      required this.deliveryFee,
      required this.products,
      required this.subtotal,
      required this.total,
      required this.orderId,
      required this.status});
  @override
  List<Object?> get props => [
        orderId,
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
      orderId: snap.id,
      customerAddress: snap['customerAddress'],
      deliveryFee: snap['delivery'],
      customerEmail: snap['email'],
      customerDetails: snap['customerDetails'],
      total: snap['total'],
      subtotal: snap['subtotal'],
      products: snap['products_id'],
      status: snap['status'],
    );
    return orders;
  }
}
