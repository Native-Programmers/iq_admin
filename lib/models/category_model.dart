import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Categories extends Equatable {
  final String name;
  final String imageUrl;
  final String uid;
  bool isActive;

  Categories(
      {required this.name,
      required this.imageUrl,
      required this.isActive,
      required this.uid});

  @override
  List<Object?> get props => [name, imageUrl];

  static Categories fromSnapshot(DocumentSnapshot snap) {
    Categories category = Categories(
      name: snap['name'],
      imageUrl: snap['imageUrl'],
      isActive: snap['active'],
      uid: snap.id,
    );
    return category;
  }

  static List<Categories> categories = [];
}
