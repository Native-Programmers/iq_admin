// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class SubCategories extends Equatable {
  final String name;
  final String imageUrl;
  final String id;
  final String uid;
  bool isActive;

  SubCategories({
    required this.name,
    required this.imageUrl,
    required this.isActive,
    required this.id,
    required this.uid,
  });

  @override
  List<Object?> get props => [name, imageUrl, id];

  static SubCategories fromSnapshot(DocumentSnapshot snap) {
    SubCategories subcategory = SubCategories(
      id: snap['uid'],
      name: snap['name'],
      imageUrl: snap['imageUrl'],
      isActive: snap['active'],
      uid: snap.id,
    );
    return subcategory;
  }

  static List<SubCategories> subcategories = [];
}
