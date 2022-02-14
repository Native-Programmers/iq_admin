import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qb_admin/models/subcategories_model.dart';

import 'base_subcategory_repository.dart';

class SubCategoryRepository extends BaseSubCategoryRepository {
  final FirebaseFirestore _firebaseFirestore;

  SubCategoryRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<SubCategories>> getAllSubCategories() {
    return _firebaseFirestore
        .collection('subcategories')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => SubCategories.fromSnapshot(doc))
          .toList();
    });
  }
}
