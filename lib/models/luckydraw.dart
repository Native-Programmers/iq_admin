import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LuckyDraw extends Equatable {
  String charges, discount, productId, uid, name;
  Timestamp date;
  bool isActive;
  LuckyDraw({
    required this.charges,
    required this.date,
    required this.discount,
    required this.isActive,
    required this.productId,
    required this.uid,
    required this.name,
  });

  @override
  List<Object?> get props => [
        productId,
        charges,
        date,
        isActive,
        discount,
      ];
  static LuckyDraw fromSnapshot(DocumentSnapshot snap) {
    LuckyDraw draw = LuckyDraw(
        uid: snap.id,
        date: snap['date'],
        discount: snap['discount'],
        productId: snap['product_id'],
        charges: snap['charges'],
        isActive: snap['isActive'],
        name: snap['name']);
    return draw;
  }

  static List<LuckyDraw> products = [];
}
